Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FAF606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=fI4zx0kW;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=zqo0r2Nj
Received: by kanga.kvack.org (Postfix)
	id F14E06B05B0; Fri, 20 Nov 2026 13:58:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC8B6B05B6; Fri, 20 Nov 2026 13:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03916B05B7; Fri, 20 Nov 2026 13:58:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B419A6B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:58:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CECB1A0181
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:58:19 +0000 (UTC)
X-FDA: 85456407918.12.552EEF5
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf27.hostedemail.com (Postfix) with ESMTP id 00F9D4000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:58:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=fI4zx0kW;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="z qo0r2N";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.151 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795201097;
	b=kctjXconUrg/qT+njZsvjCStnS/0ZScNVXfGzfkACMe7qDW8UpMpvCPiTuhxZ1ygg0ocDR
	Wy/45VQSEgn20iEZy8PRRz7+6cS9CfrvMMKUhYKttuQe8SCpoitZyYE29bPEy9zReRm8+l
	pNp49b9axM+tSby+pOoP4jUGQAcm3Hw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795201097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhubdiDktGb/dI5xNWRc/wnryLgla9NgWN7iTJfqz/A=;
	b=VtqpU3wUXIMa/rbJhSJpuTPVtP0k2PlQ0NhmrnZeS0cvfh7F6VX9LbyztxGMMeed1TPCf3
	4cpuZLJdbbX46hdncwyPmmGElaO84/MIh8on1SiP0nRWSFN3pWZe2ZTzxxx9GNOWrT8Aj+
	GDYyo2VgNyMMVZ6mFdxrGZzVjKQzhh4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=fI4zx0kW;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="z qo0r2N";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.151 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id EB0361D004BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:58:15 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 20 Nov 2026 13:58:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795201091;
	 x=1795287491; bh=OhubdiDktGb/dI5xNWRc/wnryLgla9NgWN7iTJfqz/A=; b=
	fI4zx0kWv4tjdxUH7Fk/YVkSfFKTP1FBPqYZz8rclWIdNP2+iMaa65SBLX1b1kJQ
	/5paWyTPy5oP4kyKDyT4jFL2B8RTVP568FVNRDg80m4Wd6gJvith7rY+ImuTZTI5
	QbmCDS8886TWT4LYAaDaBEB0KtFNfaCopGcqTHhYs0tpFN6BGFAXqhUQ2jRKQggO
	0usgI6RmhbM8jSEkRqLBc5dfOUhOVXYL32f5oqDCoKLO2aqNrk7PBlj47HK5O0HF
	SZ1RwdWmf9YFmc5i0ceaSEjXMfVaxHknZkaVgYaiDm0ujslbNwzWFyYMmUlAKm2G
	qC5PSIa1Zv0gia34WEZ4Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795201091; x=
	1795287491; bh=OhubdiDktGb/dI5xNWRc/wnryLgla9NgWN7iTJfqz/A=; b=z
	qo0r2Nj7bB3sPTuqKlwvCrk3lfNENTS7YZyP+7DKMFzVe6pIekxbLkPfozUG3shr
	G9NFqW0T1jvgTVFCJAXEdCd9mhyuDlubygwspyyfgkAGKnYnsZ6hjGobxrs5oRZO
	jhwUHbn/WffPaTgIpZaiwEwuU8WLTUewhmmdp4XeQ/Bh/H3wu+kXMXJBI0VufpR+
	jVLqQBh9QGC7ISjv0uLDzax70frm4jFbZvC7op8WUJPtA+C0sXdNuXFX1FiyBzXf
	2yubkS8127uPFsgYJBUj/WmuGLRpGY3cRKEr8WxRVCuSxR2zjtmsjeTMbpe8W0xp
	tJ9RV/wI4cyO4zlTcpGFg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795201091; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:L9CetiGh1YprSEdI4xEhCIDQpgbPdV5JR99U88uVgg9maTn
	yeA9Jo+RJR3Dl4J1YvyvLh+abPgv/HdLGHOb1eAcMONGQKuvr2GmtRJJjDzID9d+
	XIc4cv/3AnTdIN4MjoJlAOxFmPSmh1UuDoNOnfainz9CcnplFWTd0/Lz7g1TN19/
	Pj6PPuf9+N/RxSvPVffEVzMZSbxZHon3ZGSjcCtVeKTTiCLW/FmReGL1dMyvMYu+
	Q2KLz7pzRvVUDwucqffoMw7/Sr5owFT26909+is/GRJNY/UrinuFU1wYNljpZAIh
	9Cw8ZH1KaMObZh1lhocF/pt5CqbYhDuTWyyhQuQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Q37SVA7hNjYu6K0SdtKZ77uaZfy8rDJkm3H2aJB/Mxo=:EZv6T3kLr100RKODKfNeG/qI6S8Fj88SGKLUy2b/qns=;
X-ME-Sender: <xms:OpgAa_2nZuuSI2jcLLlw1dDNgzbZEjmEQ_CTcuLcv83R___AjfYs4A>
    <xme:OpgAa46obZSyLfkI0-OT_8a_nRhqHXD2Rb3zzoJuBzYh320HiG30QNXPrakGXT-nT
    VJbx0Pa-D9XkIEj43n-IyIWELnAhBdYd08NlKHnNSgO2QHIbNDSpMgW>
X-ME-Proxy-Cause: dmFkZTE7r8RF9hSqcjftvuz9PAP06UPcR+hYqB2uT01HIoj+VLarW6XaBBKdQCQdBgjBmw
    gUtUc+O0P5VBgZW4/43bdwNalmC4lXZ6XtzRmdZ3X0UvTRh5bGP5RfDr8IkJe7dM3QiVnC
    OZmQIPBjf0t3ig5uWvFMP1eIfMmlJ7tSEeFT245M+Ss+CzBPUlU+JN6uxIOsNWCEWkkNkK
    NyfPtf55YwmEb6maQUYsGedwyy8i+B9JPbr/UWeYMqpW/pKEB/T3TZATPStk/a7ka2ZnH6
    ua2vO9EciUBIOAF9LeTyPaZuGtplgXA8t9nQb3HfIrbsfT+TkFRMbfJvbaU7goncg4T5dN
    FOc6Of44BeQrFXxIViL6+Q5TRvE36y1xEUosO8K0k3yjLAloKzEkeX696+MXRoTalaSdtd
    VgcTl1aTEXwFhMPo6E49UkQ7B955VbaK2gp/srAgTYPoUDFYJ+DKD7SUPcDRk8Ef7FTh5n
    Q6YDsH3WSiwgKqGRc3XJeywNJiAr+Hx6q5bM+7P+ac8i4jqsynR2S+ju+2MIcV0yaVUujf
    hONzrEoY8zM6hurYwx9yP69NChRJiTsGpU1U3Zha1ipKTbOChTNBgcztBhJyeeD+ZG30Dg
    AQV4LMIjsWjppkZwA39goTWYGi2cOsyqXiAmscD8pJtkEPVlxJe50BLgu7Ng
X-ME-Proxy: <xmx:PZgAazxK_pyiqGjQemOJZEbqHlEgRy4CyYfFsTlyecyAK_l2hWp9iQ>
    <xmx:PZgAa6unruGsVyABk8XjZyq4hMOsMilQzDuaS1OLIuN9eRj1rCSuZQ>
    <xmx:PZgAa-YK0HGFdkoCIG6Kng6NXW2inNUCf7IkZntZDZdDMSW9O2esCw>
    <xmx:PZgAax27ERP2xOW6r5yqmDPzJPKS5nSCZObODpiuQCcr3w-haubQcA>
    <xmx:Q5gAa_ik1ZVbWP_H3gg0B2JVLPvWblO86PdWzWCEGti3MIL8FOnNosa7>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 87B6532A0099; Fri, 20 Nov 2026 13:58:02 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AQsIS8mXxcAZ
Date: Fri, 20 Nov 2026 19:57:42 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 "Gregory Price" <gourry@gourry.net>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: larips <larips950@gmail.com>, "Zi Yan" <ziy@nvidia.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Lorenzo Stoakes" <ljs@kernel.org>,
 "Brendan Jackman" <brendan.jackman@linux.dev>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Jackie Liu" <liuyun01@kylinos.cn>,
 linux-mm@kvack.org
Message-Id: <ae01d623-2b72-49f2-8d52-069bc089f448@app.fastmail.com>
In-Reply-To: <87218525-12f3-4259-9950-877c8e36c83e@kernel.org>
References: <20261117211635.2472067-1-arnd@kernel.org>
 <sashiko-outbox-221983@kernel.org>
 <c420ec17-b297-469a-927a-85934a05fda4@app.fastmail.com>
 <3b00e53f-b4eb-41d4-b3e6-791660da3342@kernel.org>
 <45a71e8e-0c8c-4b5e-96c9-be6f2ad0e364@app.fastmail.com>
 <87218525-12f3-4259-9950-877c8e36c83e@kernel.org>
Subject: Re: [PATCH 1/2] [v2] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 00F9D4000A
X-Stat-Signature: fs6uk3q9w44fzxthyqijj7h1pykgjuzb
X-Rspam-User:
X-HE-Tag: 1795201096-475777
X-HE-Meta: U2FsdGVkX1/zc4Rfs21BPi3DNQQm6RIKgqeZkaCkwNgAoAMuGvegFbSqN+AMQz9a4BA+nmogbDfr0k7KlfstGf4tCxpCWgfZ6wTFMslYcV+gWnP+tr10GNcx/SncYOJK9SckLrGJmn5BrVLjpoBIBo1ZvkvN7K3iFedIL74I/CGk/+sS3ykYT7wejvivr/+uuPVNYqEgBS7AgsQLbsgTZpSfO5C2O4KazMSQSdjKc/rMrf14JGYAJPXiwz1lhBo4Wiw6IFC0RTbgkS/Wuq+peyI5gw3uFuT58UL5K3WnaGLIqxsz3+fN3mgm9vG9ALAugoBle8aAQiTVTux9jOBCpOzW3xpVofp/mu0ULD2MgwlmpTntVG2Tnm5u/oCMrksQ1f+PNZgELFyVUP94vSXe5dRC+Le+fUu7paXI+W8BRJodkn0XSayxoQsUNHYL2NNN7NoWC4XwDdCR9K/wTrKjMtqM/R9O5HRGsgZXOOsQwU58DsoAjHHeR/q/Ekn9cKt4orGUzlPTKAkCA9AMIqQZuNRSAp7PschOU27HczN8/yGtYEqGR0BEOEmTISorV+nfDl+snBEfoHfm0Xrt3mT4xIF7GDoZZHOTEtgFKlywEycbRWF/u1r3cGU7xDiQP8l7mtMbpXBjegI2SWs19MY74XS9vyoV160h0Qg2bkhZrJq1H7HufCQdctGgibJBcag+HHiexPf8Iq+CIdbuGaQAxdlCUZByYpPBAsNmmvUUyVnee5mSjVKDVV0w1v1ECBnXVwq6maKnilOY2SvLBBkNK1dDP6jXGBttSi2ZmbDnqHMfXD+rjPeeUPyHHXVbDp3itfT7+zYpNDPs/uaGPbN+C/5WZg74IU7vVVPnLSAST6XFnMZskdHKGn9kIinojqirXzUZ2sXqGC/SjRtGHA6fM/Rd1Fau7xI3cH/J+5TmQeaB5WR2TlIj65wa/O58ehGSK7fXSJjhFZG9kJvozV1
 9jXUJE6C
 cS4NJY+zO2dxYBzq+E3bx95pHrV1/xIqOWSTI1GQ09xEklnp/tlMyVwXwAkQsgNl3HDXQPqvhPv/ehR56L+MTiyN7317Q5sv7WgnfEG8WGrdEdC1chatsxzEaLpiGfPHyplYSi73NxqLhrw4kK6JBhmEJd+YWADWZhLZyByDZpBp3ARXl/y2dKbFDk1XSW7OV35moGBIou8lE7SeYKv/tScEOVXR8/cOecqkjeoftotCdUNlCc334LCz1dsP6LXCq/hY9qMQmOGOe5rXNcunu5wH0ngg0xv5LqRX9wsaT29Uan0+IWFqMTcjZCbnEMU6ZfS7mZ8X6gtZbTdJhMeVPZe3dJiQ/IKTkKFRCNAOwLkrFVNnwQLGjZfdg6z0TbDQaAqoeOqtcoTqCdCzAV11dW6m7uHw9KDrA2TH04+FG6gxqbJnGirsmEaKgBQpMNbtd6nR6MQ1QQhzwZx+HqEiOQOBlguXW5e9IWMsvmnrmVwyRirlnvGLnJn/DA8H2avqepj1d/pzfTABCYqvd1b+P7aIqTEzGqwUwN5nAiaQryzUyozkNQ1IoKhFukyZ5mCZTwHNO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026, at 11:39, David Hildenbrand (Arm) wrote:
> On 11/20/26 11:16, Arnd Bergmann wrote:
>> On Fri, Nov 20, 2026, at 10:55, David Hildenbrand (Arm) wrote:
>> 
>> I like this version as well.
>
> Does your #2 still apply once we would have that (in a reworked form)?
>
> I'd appreciate if you could resend based on my suggestion. Feel free to adjust
> what you want and just keep it to a Suggested-by (No need for Author,
> co-developed-by or any of that).

Ok, sent a v3 with a minimal fix for backporting and the combination of
your cleanup and mine as the second patch. Thanks,

    Arnd

