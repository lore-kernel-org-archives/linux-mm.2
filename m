Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6BECD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 20:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E977C6B0093; Wed, 10 Jun 2026 16:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47996B0095; Wed, 10 Jun 2026 16:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D362B6B0096; Wed, 10 Jun 2026 16:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2E666B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:38:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B2B3402FF
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:38:47 +0000 (UTC)
X-FDA: 84865166694.06.C5CAB9A
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3A89B40010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:38:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=johnericson.me header.s=fm3 header.b=RnQFdc1e;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Q RgU8rR";
	spf=pass (imf27.hostedemail.com: domain of mail@johnericson.me designates 202.12.124.137 as permitted sender) smtp.mailfrom=mail@johnericson.me;
	dmarc=pass (policy=none) header.from=johnericson.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781123925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEDrxC0e7YHTg9BGEJLnFRHo2kndEcLOabEL2KZLl+I=;
	b=jyndn2RdD5K0pLlVpoGmp5ovvTNiU3+MEfT108v6R2IiWBS3u0TJ9OL9LQNAbTKk6Wao7D
	fjY9WZIUP3buMU4ZFJPwEYvffpczFyk65ULj25d7v2i4n88NH//F7fVr/qhwikUh/IA7xr
	FkqGKVAq5zdJUMQJ5VJEUAZRWKdIMvA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=johnericson.me header.s=fm3 header.b=RnQFdc1e;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Q RgU8rR";
	spf=pass (imf27.hostedemail.com: domain of mail@johnericson.me designates 202.12.124.137 as permitted sender) smtp.mailfrom=mail@johnericson.me;
	dmarc=pass (policy=none) header.from=johnericson.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781123925;
	b=GN9EQdWEufVBgaWBS2O6CON28M95lhjPbAfvHK3P77uKrunqMarNxDz5dmnpg0yoL9Z4eG
	8+WClV4wLNXsUmzyeqVn6c9Vtn9or7TRT4ZG1gmRZCQn0RxjpAp/X5Wkc+sdp/IEcUbfOj
	V98GMEEgtlH3mYbbl8P2jqBoJI4cEZU=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 19C1E1300074;
	Wed, 10 Jun 2026 16:38:43 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-05.internal (MEProxy); Wed, 10 Jun 2026 16:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1781123922; x=1781131122; bh=bEDrxC0e7YHTg9BGEJLnFRHo2kndEcLO
	abEL2KZLl+I=; b=RnQFdc1ehookfxZskeYaO0LGYH4k+xPtvLoa3oFfYCkoTFn0
	Ttg7K+wuvRAF0lBdwJlU+xe/XNjGunYkSuKCPEIknEhzPzuR+tLFnZFZp+ktFnRO
	GtvOk4bBVFEkTto3BzClF+pC5PcukJAHw6OLfB5FVw9Z5v6StXjzNZpCwftoZA11
	7GUuhQ+gmeG6cxKGRIIT9uYk64vQdXsOt6WnVeKNR88DPEnuo6S6Y9Anrp+fqIR8
	jgVpp3+hDQgA6vuVO3RnkA6Er8+Jom9IEvjRo+vghEzZwEXK4LAhm3nCvT+bf3px
	Q5FMMAeS/RTjX/X9FN7Y9OMRbhaFqlVCFS1w2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781123922; x=
	1781131122; bh=bEDrxC0e7YHTg9BGEJLnFRHo2kndEcLOabEL2KZLl+I=; b=Q
	RgU8rRJzIa4UEklCAnc+PAwkaoWMsC+u6PhAtkmGDKTEYl2fN+CtlEyzv1P1ToB+
	epglkq6CbsdgT+alHGBdNXnURyXvky2HS7VQh/nLqR37Y9A134IoyA/ySO7fgvVw
	Irwz7rIbnthhVKH5fgF0qGxvMs+ifWt6xUHAuevWd4KTckK0lhvTVbrwUNP/Vi5Y
	WaGSvS1BZE/88VDpoxmxQ323V3szRJuzPKHYsJPfabCCJafHuRo5C743P29RFY1O
	qCoLP1Hf/ASvZAQCHiNPC2STa8ZxfZaV6Vt/p6XXz0Em9ukXbwLiwm6Bo65rYqPT
	uGd+rWiwYIfxBVjcJAJiQ==
X-ME-Sender: <xms:Ucspaq7ROJCg94S7g4ApNvmWiIM15KYk-FwcGKB01eMGISMqqZWXNA>
    <xme:UcspautuioAppC5EgckFH6FaPBCNDWxu3dOShwhdGeAAVatOQRQ9CxfhwKBfVsEo0
    oJ7xrGp33oWrk_ayvA1VgPv-bTntZ_dF9hhtHT4Xsj6GS4ENM41VrQL>
X-ME-Proxy-Cause: dmFkZTGaNeNTQ3G1F1+JWzJkMGql3D6L8AUgdkqFLx0WG5ejhftcD6XNOk17L4aaI3sLyo
    JMs836zpWnZQRvY3wiKtPAVpFVuFdcwBGOM0exgvpRf4fra7IypSfeU+3Wp4jbrVCLy94M
    NVooNMv5d55qj5zihBo2bVG0kwGZBVLwYdxuS4ieBQ4SBqpCBRuhhnAtTnBGICpgg0fcIe
    nR3Hz/EB3Go9W8jzMC6yHEBv8uBcD2hYbb+iMMYQB2o60laEVAFrKuuSjBswonvVOCc3Gk
    odcH87lSsUh/amBG/pxMLt5RblP2Wa+j2WlJhSp6SQ2RVeTNecZ/Rxy5QSf99EO5UNP9l3
    Se6+hqZ/tYap9i/epw532BHzfBQkdEs5R9F/V1PLK6u6OgDA9T5ub7dSAmN4fFWW9BO637
    EbIERqO3LWEweYPxuggu2I8QB5nG/ZPtxX8+uZKMIJcFOMDx8OzGhDh2c0vlu/dO1syAOq
    svLYMTbXYfn/go0WBEHsfsmnlehos1beHVOBHH3XKslvDcpES7DepH9Ha/h9SZPRPbVkS2
    v/lbpuDzk+lslHGotkLNybQ6pPEzlJI/q9jq3S7DK94vL5G+5dtvEesArzUM80edCJU8IL
    O5fGVCoGommkM13WiiVPQnxH6+WuNSjbPGN3yuNQOUgS+iyp4cJJE3EMqvnw
X-ME-Proxy: <xmx:UcspahQly0uFpZlUjGh--NhkJzJMv4OI3yFazQLn0Zj4Rv8sNw9s1w>
    <xmx:UcspausIaR3QHHlo8gAv8Huxu_KvqCsyrCHfJZUoXhO-7cMmHCwcMQ>
    <xmx:UcspavUtHS9qlU_-DywzPzzLAQrh-65e_La29NAujNrxgwZvHINEzg>
    <xmx:UcspainAboznNphZuC_qA7s4dkyCtpJ5aA7zI5AwFtpde5H2t0LTXA>
    <xmx:UsspahiyYw0Bh2a2JnJpgkhZM9oZYoc2lr4_FWH1CPIAoGZSxqg4pueu>
Feedback-ID: ieb4144f1:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 59E002CC0083; Wed, 10 Jun 2026 16:38:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AtGJywdvvpER
Date: Wed, 10 Jun 2026 16:38:21 -0400
From: "John Ericson" <mail@johnericson.me>
To: "Li Chen" <me@linux.beauty>
Cc: "Andy Lutomirski" <luto@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Al Viro" <viro@zeniv.linux.org.uk>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-api <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>,
 linux-doc <linux-doc@vger.kernel.org>,
 linux-kselftest <linux-kselftest@vger.kernel.org>, x86 <x86@kernel.org>,
 "Arnd Bergmann" <arnd@arndb.de>, "Thomas Gleixner" <tglx@kernel.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>
Message-Id: <48594f3a-2ae9-4e1c-a575-ae54a6e1536d@app.fastmail.com>
In-Reply-To: <19eb181fdd4.6d028f442844776.3737831021032223216@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
 <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
 <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
 <19eacd64508.26b92c022125848.262962729296162879@linux.beauty>
 <4e049396-377d-48a7-a34c-91318413a876@app.fastmail.com>
 <19eb181fdd4.6d028f442844776.3737831021032223216@linux.beauty>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated executable
 startup
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A89B40010
X-Stat-Signature: repojhd9pykz8jgfinejnhhy4pietwu4
X-Rspam-User: 
X-HE-Tag: 1781123925-53751
X-HE-Meta: U2FsdGVkX1/SPurWHbKr6B6F4pU826v9oyf2HvDre/i5XMsmDt1qUv97CmK6RJCSVVS37fc9mj2ES9wy8nSuzGa4gXcEVYe9/pF4M6807NukDmjw0+aE+GJQKX474Uqyf16Qjx0/mJJrc7OxEFrHJ87f1kEyaUeEOcl2Pm+QROqtDVtyuNn7sVVP2VI9MMuMJ9m7TnfkFqsxbVRcA/mgGbu21ehn7YGnNYG2Rq8pya9deUze3dUVyj+zQIq9Lu3XdGYMbAmlZ+njmuRxnZlDztsl+s784y5M7c3467LvBDkpQVWIGOtvqj1qoBcE2kzjF78wT1ajyt2wro8g5x+mHjX4PuNyce3c41yEKTZKdy8HdbUPHkdtRoih0U2IAoq5WVgyY33CT7hNyIWZMARR/icbFzS11gusLKa9MTlBGDJSir2sCHLHo2zME7Enzy1wRzHamOzMwEcEdzsKhd7mEbmw7mRYjGRiRLo0SUXROLKizqjZlGBJEvafXuhExezngJCjuBU/1eVGUcmagTVOMziZAeaQ9YUVHKHaLuq+qh6FrPKKeCZLPD6udnhvHyglHQaNkfBJRrObi8anhcbygOH+3T6DjDSbe2AahqVJ+bFLtWV6sCOuGQoCY4mowlEVvy1sV5co0IgARPHqrB6b1/I3srdSCM+nLrRCjPPNqPgy+2ihK8yP1J2KjtHGKP0+BzKfGFpmCgFSRJUJsQGo6rnUUNVPsYgHaQ7L5zDbszIEAAutWGkmZvf3EX7uuXtiXn+09WxXraQxowRadPyWhSNk6YYqDa/oW34e5lqMw5pjd7HV55PWo0D2IsEvbdSk2YhCdk4P0au28dIMFCM8CCULOZUwUJoPEkTj4MC5xOlgZO5urP/4VBlci8KGhTFpoo1p7lg/taOJudlhdACI5Rr1MDbhem+xpS6klCRONPmv/xURwwMbG7+3kwuKQCBup19K6vGSDC5RsHxUzk0
 ztiOaiak
 ClKSB6JVdThJxWp9tJj40oA+hbWxYt3CCx971ZBqL8ayfZviiCoUMIryiaAfTM9goO7TXhVDt+gkWzIAhuxn7GzSOcM8dzKr5Ojouzf4L/T69q/T1nTVAlua+h1RNAdLeFboVGKZT7UlzrkRpwvHLkGfxRECsUnsPknV2GzJuhCA2Hkte7SlHW6McxKOPpJxejV+MI2P8Gr6/8tQ5Kt8yUfPKdMUpYbXZGNBFuwz/5Jq7/KW1BiVWTk5kNPC32rcXaOx0hPd/1giJr+orZDxbV/TDXFk/Yh1xSf6ALRiYuuk9K0kJckhSxyFwBPGm0Aq+w5XzmZabQMMWu1vp4fEqz7yYFe7aljfc/14uBX1CvYDwXLnvlnM144yExDhD5IpZmRUrE51e7ga1OMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026, at 8:29 AM, Li Chen wrote:
> Hi John,
>
> [...]
>
> Thanks, this helped a lot. I looked at FreeBSD/OpenBSD/XNU after your
> note. FreeBSD has P_INEXEC, OpenBSD has PS_INEXEC, and XNU seems even
> closer with P_LINTRANSIT, described as "process in exec or in creation=
".
> Linux does not seem to have a single equivalent today: current->in_exe=
cve
> is only an LSM hint, while the real synchronization is spread across
> exec_update_lock, cred_guard_mutex, and the exec path.

Great! Glad to hear my suggestion (and the patch too I linked in the
other email, I hope?) was useful.

> I am switching my local WIP from the two-fd builder model to one fd,
> closer to Christian's sketch:
>
> fd =3D pidfd_open(0, PIDFD_EMPTY);
> pidfd_config(fd, ...);
> pidfd_spawn_run(fd, ...);

Glad to hear it is also one-fd now.

> In my current local version, I still use copy_process(), so the fd poi=
nts
> at a real task_struct/pid that is not woken until run.

So this is an interesting thing to think about. My hunch is that
`copy_process` is, at least in the longer term, still doing too much! In
particular, `struct kernel_clone_args` has many degrees of freedom, and
might also make assumptions about preserving more of the parent process
than is needed in this case.

This is a bit tangential, but one thing I have thought about is having
"null namespaces". I think the current (i.e. existing clone API) default
of "share with parent process" is a poor security practice (more
privileges, i.e. sharing, should always be opt-in). But the opposite
default of "unshare everything" is expensive since creating new
namespaces is non-free. The goal of the null namespaces would be a cheap
way of creating a more isolated and unprivileged process =E2=80=94 and "=
cheap"
here is literal: a null pointer in `nsproxy`, no allocation, no
namespace object, no ID. This null state would be what
`pidfd_open(0, PIDFD_EMPTY)` (using your example above, or really
whatever the first step is) hands back.

Then, from that maximally cheap and unprivileged initial state, the
`pidfd_config(fd, ...);` calls (plural important, I think!) would opt
into either sharing or unsharing namespaces between the child and parent
as the parent sees fit.

The larger point here is that insofar as there are not good defaults for
things, there is pressure, whether in step 1 or step 2, to make larger
everything-at-once configuration. But when we think a bit outside the
box to create the good defaults where they didn't previously exist, we
can end up in a situation where a minimal initial blank unstarted
process, and the builder pattern to initialize it, are more "natural".

> Following
> Christian's point that existing APIs can handle this not-yet-running c=
ase
> with ESRCH, I currently make ordinary pidfd operations that need a real
> started process return -ESRCH before start.

Also glad to hear.

> I am not sure yet whether Linux should grow a general exec/creation
> transition state like that, or whether a narrower future-process
> lifecycle is enough for this API. I will think more about that when
> working on the pristine process version.

Sounds good, as I think you can guess, my preference is for "yes", but I
agree we can see what you end up with in the next patchset and make more
informed decisions based on that.

Cheers,

John

