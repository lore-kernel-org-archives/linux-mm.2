Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A6DD10F92EB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6786B0092; Tue, 31 Mar 2026 15:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF776B0095; Tue, 31 Mar 2026 15:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5366B0096; Tue, 31 Mar 2026 15:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA326B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:07:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCEDD1403CD
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:07:24 +0000 (UTC)
X-FDA: 84607291608.21.8D92BED
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB3F740003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:07:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yp6WDvvh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774984042; a=rsa-sha256;
	cv=pass;
	b=X5ggX5QzjoDGap9nim9fBpFNqREsD1QCh8SpkT4koDu6L3D6Fs1hjAEkANE6N5TPU/9e5i
	d7NGIlO1Ti4i1Al9wBezrbJnYZOKVn+HagoaaQEnWzRavyuu28AxtQ2OwhGcIdvf6I3pL4
	kUuO4FSfZOHPcZfo/pSH+uKrW+jwcGk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yp6WDvvh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774984042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0ubV1DBOF5A9kCIZQ9FzFvFee5p/FpkVBHygl0v4P8=;
	b=MHaYkPKq/eU75sl7nNcWtLO4Re6v50qtVVu63T6VqMsAmk78wRx2LA/pXlUGk8LCqdHhru
	AxJ//w6dD68qw6XSH6b+d8/YFRrI59rGhG7eqO9vCd3Z23y7fbq/yCBXBxDn7/oSPxc6mk
	nLOiCeUzeDp4VzL65ytZG7326sWwU4U=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64eaf8aa893so8316377d50.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:07:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774984042; cv=none;
        d=google.com; s=arc-20240605;
        b=cCYK4qxOn6EcPJYqNpM+p7Zp/PHEi2aWNPmzUnZ7LtPq2kYo4ecz7aMwNNdrGriXbE
         1JjaIJIVYugO/4/umzgCyu82bqH4/JPvTZK3HdMkC9I9synJbYD2SEdubd2ldV9BeV1K
         yGMcCdd1YWEz2TUqyOfakljoHCmW7uE/7a6VNHvVMS+LdRhNVUY4IX4WzxYxkHCyppcJ
         pwcxtAgmzfXrvoY4xps+IPk/hxg000u9u/8ksvU18vvsHeIVUAhVO/gpyORfl0mK9uf9
         JViVjCutvnGxrY487Gg6TDLowJbcHjtFrHLLdz78yMhaF68eMT/2hvmB9UjuoLPL8TEP
         6SKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z0ubV1DBOF5A9kCIZQ9FzFvFee5p/FpkVBHygl0v4P8=;
        fh=MP+K8jmCggVlpgOiXZtahz+8XSI909pfd/hrryQDAVM=;
        b=i1f7D1GQU3hCYBLwLYDT8R3yrvvU0RnmHYL22DUU508VYN/BUh2nYlqEUQG5Vud1On
         tlI06O8Bn0x0FwYMmQ4UE8PIFyNPqrnk/fbm1Z/JmtBdtwGyTyxK3I0k4xqV9hXT/hqm
         ywgYXyDmhZ7p6LwKcUtXlaera3ZdQeBpUkRtmMAieEwEpp+vD7T6merUS85fkKETDaFX
         1UdcO9gDzgBtWnHNNH7XM74ZG7aUaS8U/bYxfwZSUUtY0eTv8XEB0jYAIoTVuV9FKaYg
         Sh+st1mubVrUp+Ixd0+9L22uCFBr7BAH6+91cxbk4xdwBu/qtxoDGP/PB2wky0zJzM9p
         Hf5Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774984042; x=1775588842; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z0ubV1DBOF5A9kCIZQ9FzFvFee5p/FpkVBHygl0v4P8=;
        b=Yp6WDvvhoOlsd9wGAM4cQRsUHkyqKK0QH4ygx+63xJbyKIUJ2VtOehpwV1sbyNSpdd
         7lbwfeOEBpqfgD3lGYfPlWNphKkOcIfDSy+NWLcLTAXoGTxcn/3LFEPUbLuS7OSTzuJT
         vquC/4N/vqRG5hcTPLAp3I5hfTaTbpklQoMraJHxV7NMkIWq7uRbZEjaTR188zabJTuF
         Brua49GuaziqfzBspFKGsQ84xrSttuxFJE9QDD/vaR98wkLt8cLaowLDeQbB0DQBqavp
         m1jvOQsbn7Y4gnf0iURDNt1CcBvipZsFSiHMDigT/j3ntiIZdaQ5xYs5AJJl+i6gBdyD
         rg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774984042; x=1775588842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z0ubV1DBOF5A9kCIZQ9FzFvFee5p/FpkVBHygl0v4P8=;
        b=PH1NZZei388r1tTb+UpzCUDi6qONbXdvJo7yV0jA8PHoscITdqGBzNpEfF24zVNWf2
         8nlXEsXTJT6EaNYS9wENxT7W+ZachwTc06E7NmgLIG3qVlZSz9yoaCdoSBBZdGgAAPuz
         u1xCkCAfeAadwm/Mjo0hNq6yNIfhbegdLcw3tG7CyaNolkxe2dxgOIZrNX5lh1KPwhIJ
         fFIbIL7GoyfvEIkHuazb9KSUUt1ukxtSYF/GKmhZ7OF5NKHv6YxAjASAEq3UHbYyxj82
         ilPjkKhYS685nqRA53DquLRlnOiLkqE82Z300q1jHui6QW9vNVD7mtoVua6KWfrVvEm5
         L8xw==
X-Forwarded-Encrypted: i=1; AJvYcCW5gFVrzv2tlcSUxBEAZwaPZb2pJ36TV/oKrjsbhTlkbIPo2jiody6It9wLFHqQhCb+dZU/zrSA9w==@kvack.org
X-Gm-Message-State: AOJu0YzVC58z++3Ir8eW6Tw6qRC5typKQ6jAfIU0PbH54cc2x72Y/94u
	3eAG0HCKqXX+QCuZWs3f1wxaE6dgkcZJYlgz0i+NxNpppmc+ukI5068Zr7llOn52mun7U9eyijK
	kYEQ0gJpJL+5vHTzVk2kE+wOIac9oEdk=
X-Gm-Gg: ATEYQzxZHoJ9zH7OgOFdeTYtCjf8dg+svGhfkvDdSd1ON9oMdzxG5CXgRyEW+vaKWu1
	mz/+/zNJNPbv09wfGEuEAqCVDsLE56kuH20Qk7NplOozQjJY8jbyGzCyDVPywO3NJAszFJG5M+W
	rPwcq0aXFJOm1FI98BGksz12AB4g3OxB/IGlg+Jsozwme+aMt9QjAmsrJgE4paf3SDupF8SCDFs
	ulfuY3C8kMeLfa2RazFeOHh5qlkay2d5XKFN9M/oI7PBWk0XO79DqHzOC8nk0VxYIMTT3pQ1ccX
	LPP+ZsrUTbApEfYGdJ+1v1JkAhIesLah59geNbGNzA==
X-Received: by 2002:a05:690e:d01:b0:649:ef87:5bc8 with SMTP id
 956f58d0204a3-6502fd9a768mr511350d50.7.1774984041678; Tue, 31 Mar 2026
 12:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175639.4066033-1-luca.boccassi@gmail.com> <CA+CK2bCKJ8rkJ_onp9Za0KNuWujH4Gzue3a=HvwOJAK2tYhReA@mail.gmail.com>
In-Reply-To: <CA+CK2bCKJ8rkJ_onp9Za0KNuWujH4Gzue3a=HvwOJAK2tYhReA@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 31 Mar 2026 20:07:10 +0100
X-Gm-Features: AQROBzB6bbhjBgXc0VS9CDTkKwmwHBmIOReMXh39R-clsmpO0UQlaGcKmky4R7s
Message-ID: <CAMw=ZnQcAggXOXY2s77qtgTS_d4td-5PXeMXEkMEVwnMFUrGPw@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BB3F740003
X-Stat-Signature: fbhy5xc4k3aruunx6kipm98foaqcca13
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774984042-966439
X-HE-Meta: U2FsdGVkX1/KVIcJf5Go0p1iJF5l3iOOGRCaqqj0Km+63B7Sdsb/X94rvgbE8e+yGa2nkQyEDVef5Z0R4NvhtoSUP74qSLs0kVROy+SOgQAS7dNuCfTSwcnPnP7D0FN6bBxHb3nNPwk/GD7njcmjm/sgFyeW35yeMLpThH5H4ML96DMRSz6UKYblLbi1UouPsNSxNIW36lePRmqOl3LLMEnddoKQBRdIDNX8AiMmoT0beKfRSjfNcHiZMIlsz0OJW0Jugc/Gm4JmiyK1IZKCoOEeEJpAuiCNd1AZXctlIlMtvRupcpr/OfDDj65CI/z7jOs41yYdb1Jz377CjsL36Nlvyxdz9CFYDuuwLMW8PDMDSskTOdylQqS2WbuFjxqqvnfm9w2rO9OglyCLRvz2Ru9FBeJ/Dm/iZWNmaJ7Jp8WXv/jPOjTab2zYeleh3AeLVEqnXaZ+PpjLIJiAtK5FYw4HUES+PR7byUrygQq4SWzx+0J4w6JlrWw2mpSxmaQYTDw9aHpca1lAjkWbqPAoJOAQGr5utVBJwzagKnqimphdolRttQbSQ519CqQ4m5fdF8uqiLlk7Ix5TjBLOShFpI9WsOG2coWiLfTGuIIkhKe52+VmIE7q0SmfkLSGSfKz3SwV8+SamUrcoOYKW11P7pnv70xLtaxj8uyGjDwXa0m/BFpI6ZUv/Gdmldln+U2ITt+QGWStPC7zsg+DaNtCdeKTL7jiYESSWmaY/svZ5S5J7lQiFBBeTg166MmJu2wo6VjiZoWrYxd3qaBMvKYhXX1puFGCIEfTEARCbMg78QlggyYWmFsAb/FvmDdSr+F+BVTQgI8B15zRS7/rANOSgnnVafpg7ddzs0JHrQSfWvEhzb3PrjtjB+EpCGdBraBbRF3hqi1CbhenJoMWVkjGy/GZNf7e3ncs65mvSJbYXVuu9Na0VmpiDYp4r9W/qSHn625PlGdid7g/iduq0BV
 2HuFZ+sT
 wmWy/1zwi/KCMrLhXck1Wg9q4tOE7BUHqLQEWg6M9+jMOzn9tWfEiAHa8lmWp3IzXWgopCuO2HCv9JgpxM4BTPKG/iBvVH/9Kg1DQ7UeYo+c3/TkxffJI0phtPfSBivyxxm+fnSES14JtK50BxhzjwpdT2fVBq1cYaV39V0BKdS/fYuaWoxCQNdyKVh10mQvgFFEf5bfPi/Nt2DYocgrHcKr/oUTJsSjChQ/ANdB6r+BBSCK8t91DqP5G4LlNzQH7HrUVvZP6M7nU5cb4BU0LkhP+FQDSOzaje1k5LbMCX5hhZ7wVaGY0vIRFpf1H4R/t47mD6ZzVM6s5FQcuuyE7ifr3vU987HsDV4RyVxOkQY8LgPuqyS8reOPUckYQ5vaOWHLKsUsgUK42ydN7e3PKKF9K1gcnz2G8pLhRJyzL88xaXQ1c5kh3vtVM47/QsrU3DRRsb8+ZH2CSUNpSd7OwQZ91Y1qeNWEBbFtsefPZD5qpqb1PA8ugtM+k/F46J3gRBG8wxledKtv3p7odlRO5gbrvL72CEUb0LAiVlEczoOwasSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 at 19:34, Pasha Tatashin <pasha.tatashin@soleen.com> wr=
ote:
>
> On Tue, Mar 31, 2026 at 1:56=E2=80=AFPM <luca.boccassi@gmail.com> wrote:
> >
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > Userspace when requesting a session specifies a name and gets a FD,
> > but then there is no way to go back the other way and get the name
> > given a LUO session FD. This is problematic especially when there
> > is a userspace orchestrator that wants to check what FDs it is
> > handling for clients.
> >
> > Resolving the /proc/self/fd/X is lossy as that has a hard limit
> > of characters, so names might be truncated. Also requiring going
> > through procfs and doing manual string mangling is not a nice
> > pattern.
>
> Hi Luca,
>
> Thank you for working on this.
>
> This needs more explanation. The way I see it, the user orchestrator
> can be the only one that has access to /dev/liveupdate (and this is
> actually enforced by kernel). It opens it and creates session_fds for
> any client out there. So, the orchestrator already has the FDs and
> sends them to clients(e.g. via SCM_RIGHTS). It then monitors the PIDs
> of the clients, and if they die, it closes the session_fds for them,
> as their data does not need to be preserved.
>
> Could you please explain why the user orchestrator would need to query
> the session_fds, since it is the one that creates them in the first
> place and has to keep them open in order to preserve them during a
> live update?

The orchestrator cannot and will not hold on to all this state, that
is not possible. It will simply hand out session FDs on-demand via an
IPC, enforcing a naming convention for the client, and immediately
forget about them. Clients will hold them and use them as they see
fit, and then store them in the FD store on shutdown if they want to
commit them, and that's where the orchestrator will get them back, and
they need to be verified that they come from the right cgroup, what
the client's portion of the name is to be able to hand them back after
reboot, and so on.

Aside from all this, given the session name is input to the FD, it is
also good design to have a way to get it out of the FD again on
demand, regardless of the use case. Right now this is not possible,
since resolving /proc/fd/ is lossy and fails completely once the
session name goes above 52 characters.

