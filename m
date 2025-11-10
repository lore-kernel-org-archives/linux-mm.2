Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBE2CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7292D8E000D; Mon, 10 Nov 2025 10:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9118E000B; Mon, 10 Nov 2025 10:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7E88E000D; Mon, 10 Nov 2025 10:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46F1B8E000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:27:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAB065259C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:27:26 +0000 (UTC)
X-FDA: 84095076492.07.579FB68
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 028DF120004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:27:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OoXpbFI5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762788445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xx5VH4vrYCNCYpVzx/bKqrzvT5nCviGfQ8I1/CSh6+0=;
	b=orpKR4NxpdDY3/ZAMzJji0dKQnA1psmCIsI7CUjtzt/Oh72T3gYQCp48zFMSBmTBQCf8KM
	0RtLB7mowUwmC33Zoy5tdEJBG2U3RG3GSU8FU/e0tcNsRDXpKWK36fHTwHNP4dVb/w0tDU
	KAj2+zvWr7E5S3IxFkZWxXJpzh+ANgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762788445; a=rsa-sha256;
	cv=none;
	b=NJkLAhE6tH4I8Wp7ELvv2TLWw7wVoZUvoBbpbOqFU2aezlsR1KiDli8KoKCZq66bhlmuDm
	V1F6U9sVyzVERNac+/JegEWXng5PjxdEyvOC2DAyT9KCP+WAzUmlPS5AgiZrKTlsRxwdHe
	WzsDy2zNVsBYk8nuIbonxuRcg4S0Slc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OoXpbFI5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso4739441a12.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762788443; x=1763393243; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xx5VH4vrYCNCYpVzx/bKqrzvT5nCviGfQ8I1/CSh6+0=;
        b=OoXpbFI5P7omhPIgwSq3lHUZEOpzYja8RQEM5TE83D2Va+DYoKUX9CGs2IBoS7wFGl
         Bgb5p34Aee+5JvtREgXNG54y4e3wpBQT4T61wp2FJGqrPi0aRxa5aRlcwm2XDttNJMQt
         uX3VyGNOUxcRijjcrh9oXrYYtIUZiJ6N/Uj5Uw6gdW4Z56r+hL99t5PTpyj5K5gPYvmm
         zNISJy8hZY6piM2K2BDxcANVSa8lVCVGWVjktp/JPIMgX+SEMb1fzwcG9kgviwlvqKT4
         /AHqc/ZN2xU3Eq1MCuGx9eQyJw5S+bx/XOOHvRVZaaFGMlwWnCmJFS+L3vPS0AEOf5iN
         e7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762788443; x=1763393243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xx5VH4vrYCNCYpVzx/bKqrzvT5nCviGfQ8I1/CSh6+0=;
        b=Nfh3hAkxDGvFxHWnOQWF+Pu9YuPA5hG+q5UnysHg+hnLKDFksasFeE/MGOC3TyvVG6
         YKfgW6y9WniJ8IgsPGCywbDPsY6DE7eyMSPwwYLXl1SLbU63pXaXqHtaFSvWlAoI+Kp5
         umUAo3vYet8ujBMC6+FiLakYC9sfgpBYBDTJ88h3MFb0Sfx6JHslzcyK9lT0hvu4vi7D
         azCtDhZOO2coNZiXkqRMWQa5xwrHfVvcDqUYTxRW6FJlW8ki8Pkii7oTohqXLd98TxoO
         k7DyjbcEDn+DVFYY81wOYbb2hlfeKEQUC/uEnFFK+mDgPukP9osvgaKR7P6y6CjllsLW
         WpgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlFczKviQwnuk7fPbh9gkJ/uiUwWCEgQhMTx9vyQ6LLFS7vJUkCqvyvaET+YG6fAntcb7/htS1Dg==@kvack.org
X-Gm-Message-State: AOJu0Yxb8TqgEdnrYbEPqwrya8EwxPk+qPgeEtAJ3kXV60DVeR2gt+50
	PcA/ymUldGAOXeXdCEHB78pGy4aLvUAxzk0a2R40QmOosH2GDdehoqGaxkD9pyo5KQeTost8Adq
	hUgH8QffTx+3FzGhK0KN61Rl5eJn9WLSL3ArDjiXccg==
X-Gm-Gg: ASbGncsbGm8cHtavfJOHva+ZHqSHClzm5CUD4khss044Xs43jyDQ4Ol1yQSNUUi3GQG
	05jHWf9j5NjdtVGjKa44XQ0CxSPw6uJofiY/AhYSL+enP9sP1eUKi/hbwJe8/ewqQ1OyBMQB8Ky
	V/TrvJfRyOAfrON1xJI11Un0KlqE/jDHrEDhWgRy8Kz7MR4XIZIKW0M9R2U37H3+hWNSV0hcjo4
	o0Q5c/Bqt0RWjdcznN2zlQsvns55TRUuC0tAYjVxbuZh7+vFM1dA3BCOG2e0ZrZXLg+
X-Google-Smtp-Source: AGHT+IH3MMnfCX6a3z6KUPljUpeObG5OPDBsINyyjGmXqmi/rDT84EI39PSGtuUazEgx1PPu0eGaSKu77yp++hDXvLE=
X-Received: by 2002:a05:6402:2813:b0:640:9bb0:a059 with SMTP id
 4fb4d7f45d1cf-6415a078158mr7201302a12.10.1762788442919; Mon, 10 Nov 2025
 07:27:22 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com> <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
 <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev> <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
 <442fa82e-16ef-4bde-84eb-743450222468@linux.dev> <mafs0qzu69gei.fsf@kernel.org>
In-Reply-To: <mafs0qzu69gei.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 10 Nov 2025 10:26:46 -0500
X-Gm-Features: AWmQ_bmW_CU-wm8DFynzZQ_qvdh98IjjlGR3MaYCYIdL41bju3LuBNxGSfrd-pM
Message-ID: <CA+CK2bBEe16x0em1gRxQD3jhfV9t3QA2vx5ifk2pKb_WEoMTeg@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ibbp9qw9ufukxpg8ryg3grabaoxbwoyc
X-Rspam-User: 
X-Rspamd-Queue-Id: 028DF120004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762788444-886400
X-HE-Meta: U2FsdGVkX19KeZ2pnvxGQRiTl2v2dzZHtwKIUwAM4VdJ1eET0w0A0U50TMtTvougGi0cYSAFV15uDsH3PCbA4ItdSol6g0ycqkowhoEnWPODzmcoKMUGqv0qKBeMlMaoUNexgNtKKU1esC6g6iHuunqtsNpMWC00h26XkBgHqAFBGCGQViEEWIfEON0TxVJKiEZVKKuB8hqGYeFrjIRXc2wiBM2NrxGMNmY3Nu1VRhBp3/jtcpZAZTmTFnKNBKthD8QE6E/QmLNqcsLu8IyeyOcvzU4gqa3EzvU4kjiVEuHA41cQaQlc+ybJ6fCla121lKGN8EnXEtAtXbCx+8WXR091tCFGKXeDi6e3oTvY+CJcNATitUgkzl5V36yAh4x/tUmPdC89aQhHTFKCh1otchxpDGG1AReuK8mMBvYvc7qHVEor49KhPc1g0xnca448D7X/4hwKnKy0oYnlBas6DJ2QxtPyxEb5fhatxWFf/TRLr6Xb7Wz6WVCWWgVBNfqcQgYN4+ltapIiBVLbS/IKVmngccyBKO7jrrqaq8PD/DFvOVbnTFs9ZKOJelqCNOfCt/IGb9NnG+qZWals+EnbjCfMF2s6OFHooZrRb2uTU+mcFfhhMcBA6DSCGvpF20sm4W1tjogEKJiOdxzFc9WpoolGq8G85btplJoAnJ+/s+hKgPJqnSeeXBFx4KQWB1LsRuvxtpkfdf8h7pz3ZUjyHd+/IEn9XHKRxFFdCxsVMD872eCwvUJKxcQVhebbYFi92I7Fup3a8MNFPNYxkEkCMmJpLbRw3uU6KHQ931NY2wF+0oim8bTqhVALCWrk3psmuz9xnepCIDb+D3mQ1wAo4TCtbEOiHrnQ4lV/vYF/RlZY8h8lpvmdHvuD4suQIsOUut6JCe8oPRaS3z8c8kYAylAyWseADvN6SCiE5ZETMZTmYofQYt1OFj5B53n+8Yq0R5gkG2GHi60Fv8L3aUs
 RRsSYoD9
 +uevsOYWSvgprEVYZBydHFyY1s26XA+6v1zf+tmfTyWAIgg+UH7z2DUHr8scmEycg9eftrBpY59PsCDS7jPwHO6HTYRmkyu4meGiDp62fc57zak7tMPQle1iTMPu8FP6SnisojPUn7tgPmQjXIXARx71yfCK58gsaYCrFPKV+jhVosLO89r/A7NydQkpA1205+iYiJOM2/oHzSWn00CwukgLWbc9rXL5xxvFyGOCJxLoPIQUA9gVBQAAm4XqOI0zdcWbKNLkkjsJuSkGMZv1nF3Gs6W5rAOTZNv4F2hYccsPS/iE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 8:16=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Sun, Nov 09 2025, Zhu Yanjun wrote:
>
> > =E5=9C=A8 2025/11/8 10:13, Pasha Tatashin =E5=86=99=E9=81=93:
> >> On Fri, Nov 7, 2025 at 6:36=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.de=
v> wrote:
> >>>
> >>> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
> >>>> On Fri, Nov 7, 2025 at 7:00=E2=80=AFAM Pasha Tatashin <pasha.tatashi=
n@soleen.com> wrote:
> >>>>>> Hi, Pasha
> >>>>>>
> >>>>>> In our previous discussion, we talked about counting the number of=
 times
> >>>>>> the kernel is rebooted via kexec. At that time, you suggested addi=
ng a
> >>>>>> variable in debugfs to keep track of this count.
> >>>>>> However, since debugfs is now optional, where would be an appropri=
ate
> >>>>>> place to store this variable?
> >>>>> It is an optional config and can still be enabled if the live updat=
e
> >>>>> reboot number value needs to be accessed through debugfs. However,
> >>>>> given that debugfs does not guarantee a stable interface, tooling
> >>>>> should not be built to require these interfaces.
> >>>>>
> >>>>> In the WIP LUO [1] I have, I pr_info() the live update number durin=
g
> >>>>> boot and also store it in the incoming LUO FDT tree, which can also=
 be
> >>>>> accessed through this optional debugfs interface.
> >>>>>
> >>>>> The pr_info message appears like this during boot:
> >>>>> [    0.000000] luo: Retrieved live update data, liveupdate number: =
17
> >>>>>
> >>>>> Pasha
> >>>> Forgot to add link to WIP LUOv5:
> >>>> [1] https://github.com/soleen/linux/tree/luo/v5rc04
> >>>
> >>> Thanks a lot. I=E2=80=99ve carefully read this commit:
> >>> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d=
83f0ff08fa.
> >>>
> >>> To be honest, I=E2=80=99d like to run some tests with who/luo, includ=
ing the
> >>> selftest for kho/luo. Could you please share the steps with me?
> >>>
> >>> If the testing steps have already been documented somewhere, could yo=
u
> >>> please share the link?
> >> Currently the test performs in-kernel tests for FLB data, it creates a
> >> number of FLB for every registered LUO file-handler, which at the
> >> moment is only memfd.
> >>
> >> It works together with any of the kexec based live update tests. In
> >> v5, I introduce two tests:
> >> luo_kexec_simple
> >> luo_multi_session
> >>
> >> For example, with luo_multi_session:
> >
> > Hi, Pasha
> >
> > I enabled "CONFIG_LIVEUPDATE=3Dy"
> >
> > # ./luo_multi_session
> > 1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module loaded?
> >
> > # ls /dev/liveupdate
> > ls: cannot access '/dev/liveupdate': No such file or directory
> >
> > # grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
> > /boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=3Dy
> > /boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=3Dy
> >
> > I made tests on FC42. But /dev/liveupdate is missing.
>
> You need to add liveupdate=3D1 to your kernel cmdline to enable LUO and
> get /dev/liveupdate.

+1, kernel parameters require: kho=3D1 liveupdate=3D1

>
> Pasha, your LUO series doesn't add the liveupdate parameter to
> kernel-parameters.txt. I think it should be done in the next version to
> this parameter is discoverable.

Yeah, that is missing, I will update that in a standalone patch, or in
a next version.

Thanks,
Pasha

