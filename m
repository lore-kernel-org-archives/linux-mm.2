Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8376077B69
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jO6fHT46
Received: by kanga.kvack.org (Postfix)
	id 9908D6B05B5; Thu,  5 Nov 2026 14:35:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4C46B05C5; Thu,  5 Nov 2026 14:35:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793266B05C6; Thu,  5 Nov 2026 14:35:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFF46B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:35:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D11261C4695
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:24 +0000 (UTC)
X-FDA: 85402069368.05.21656FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 44F7F140005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jO6fHT46;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907323;
	b=1xAfUhWkIpduj4CrDf3jRDiHaQRxZsyIDMJp/4eIcb/mvY3AU2UlrUUHO5mk4J8hWP2GMR
	BRfyeXgyq0AuBSOcQA5yNtCLL5U2CyUGTAjeJvVJtUg4RfTW9xk8PlHfvBQPdeU40TTcDG
	IuV6dsSJIGiL0x3yvgdpKnPT9OfXfR4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jO6fHT46;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907323;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5h8pyB6ckh/Fez925GIOXUwCgLju8hiN+2v5AZq1zRc=;
	b=qWoAdlsjNcYa+AdyU9qnsOGURNf5io/Y9SX7r17VRMqRXxl+qtlKS6l8PMnpBZBfLTL/NQ
	jDS0DO3qchn83DKOzlmVj+aXz+gJofkehaoqZZ0qE1+b5hjbY0uAdtzJrsIHT895NWOX79
	yyVTnfCK3sVPFMJMSQtouRbQViK/FjE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D753760172;
	Thu,  5 Nov 2026 19:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914A31F0089F;
	Thu,  5 Nov 2026 19:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907322;
	bh=5h8pyB6ckh/Fez925GIOXUwCgLju8hiN+2v5AZq1zRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jO6fHT46k3cC0x6jpyWBno3seAJmOL41FS/48htjx/g/4KS0/AOvvTQNDrK+N2tPn
	 eSg4IyWf4G4FhYkE6vVJAuVVPft1L/scrcZOgLSXExy1eZXqRymthLKJHvCZEjshCQ
	 FspK+EGuUBwYnyZw5GP5uQusSuenS6tchWvoKCkW0w6oxWb8XCS/IIeZBRu2cLLxh9
	 nBalMctIah8ehQC7+J0mGQu5fUWTHREU0FPypSNk4wCDvlkwmfvT2GL0NdosSNP/Lg
	 beYsluA0YIqlRpFoO5FkXTCF87+/0zOHnBlziRvMNQSTcpA2DxXltjclWi+UeZDyvx
	 KCSkb1a4yeLIA==
Message-ID: <sashiko-outbox-199934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 04/23] proc: wait for the last user of an
 entry with wait_var_event()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-core-v2-4-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-4-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:20 +0000
X-Stat-Signature: gxoym53ptye1tgngz15mttbz14x5opqz
X-Rspamd-Queue-Id: 44F7F140005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793907323-250956
X-HE-Meta: U2FsdGVkX18RFBvuIhhmqsddnT5CtoY7cKxPtnzWyvAOFGYUdqX4ejYfJrWXyK7lWPVd3SkLx74ES8U8ZqjriY60hmPGf4Vlimt656RKQugnk7AxdYKdY/X5ZI1RCT6BRFNf6Y87oHTDGrSlqJeRUXU6++CSKvnRvyguev5BBEGMlVhGEFq02TAX4u1/iifk82QNSAFGX3ornMW1dSTti8J/xXkk+hEwv0QzbqVqjNJmL4n4E8evPoBKWTtiGlc5vMXIm4uRU0yyimXLXY1WjGGinQWwdciM8uvm4pjX8x6tu77lFja+ibNBnyyVnVg3tPJty0UmzGXGOOLFU6CnRA41OgmPJV+pukc6SYORH606VHp5pBkomLgp34Cl5LgoUAaZ0YErER3qp9yp4V41uHfHoxrRjRbjaGzCd/aZP9H9xAZ4rr8jE4DK+exWIG8CBbGrCV8owXR+tZVVM5EiPLG8vUSZJ4oL7am47Th2+Pgh8XdsaDxSgf2qMI1hep1qrnhB/ZKtTixkseoIxXkYZPkEEuNkEYqIbSSAn+WkfRjPyiY8kMTRae7Ov6hndtloU+c4GfDNPQtCKpXbFr9JpuTnbcXsuG9iY+v1GVnIk18Qb+UyHsc0GhEZacfAMujoZ4xR4Q8ovIrXzM7tYSlVvT+oROKBA48xBaMHERRgRPFPciP9AaeFfHxTHwVpWyrlULAJweM6U32Ee2e19hY25AMpMFK9sQ5O8NkCEIRQ0zDM4VXiUtHucsGYGQmWvlz8jEmXlh8/CdfbMpbT+fiLnbGgGZy1JljSLy1MfimDMNzx79GT0tXnsXyvLX5nVWB7zUuevpzthP+j05UHD7UrijOi7smmndFMTDOLFoUkT7s1R7nak5pm6FXYWy2FJSJOx3znVdooFtJJWC+q/zH7HLEjgJFcoWVDxPCYD4dHIC2ZMIMA7jxprvAigNKbRXMtWSLJ6f8/CnbJkKlfQNn
 lLaI39T8
 N/gPptmylxSxqthwJ3B4Eer6igcfVMwb53jtEtfq7tJ3u3xhc3KWrntb1haeLP8SRvLDCyilpNr34y/RW5T4a84CVoXBWahfZnnV41jW7HVO+IMPseibBkFVN/oB9kxt0Avign0IZuwaDip1yO1hcJoNK7Q65uCSw19vFjTzKq6zbsVn5XbepVcGw9ZIKrpx51ptvVjDn6vvvK6svvyadkbEXOKNscannfalMgXrYSxgwU+G+7tHS4fi+oBPzDJen2ahngvjFJRDca21g5fnX9GdaP33JMP0w5+Fp8CAO8LSxB0dweiw3M3ItiG1kYYSpZ0wmqLodz7LDYfzXG4Ye1KTu5l2+R0PG5PTrfRbhB1laFNYuNidF+B+p6GmAPkIBg6oYshNazdW/407yl2Aa4Nn/n5GHeHjoUU6XOBKiQ0FOmZtIAPdWGf1wpLbLWkZ8KEWXP1aj+RUWQ9ZFC6oZBmLgz9qSRwDtnD7/fCBGEWGHWG3GWmvOzxZPDbm8bqzuDj7AxdrLaUdVlnwp5EZ25n3GsCXifzOkTrjgZ2EVxQrMO00k8jiFuQpnQrIDqvsc5OG/LBuNlOGjeRQ7iHRsbvfigb7Y3aEj9NEZ+TDAXval0sF9Ozmq6+112+3NNnDjzUBK9TswdvW/HEO0KvIH4UhXxNhhJL6JgpDNO4pSrDnuKp+zpEekVPHS7KmmbvQP5oUTztYpEMXplHtyib8kXWThXPwLc/rkohL5trhuTNERlV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] proc: missing acquire ordering in proc_entry_rundown() wait_var_=
event()
--

commit 983e734e20cf0803ce3936df6614c8375020b212
Author: Christian Brauner <brauner@kernel.org>

proc: wait for the last user of an entry with wait_var_event()

This commit replaces the per-entry pde_unload_completion pointer in
struct proc_dir_entry with wait_var_event() and wake_up_var() on
pde->in_use during proc_entry_rundown().

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 66a3688757dd7..8795add1898dc 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c

[ ... ]

> @@ -266,11 +267,9 @@ static void close_pdeo(struct proc_dir_entry *pde, s=
truct pde_opener *pdeo)
> =20
>  void proc_entry_rundown(struct proc_dir_entry *de)
>  {
> -	DECLARE_COMPLETION_ONSTACK(c);
>  	/* Wait until all existing callers into module are done. */
> -	de->pde_unload_completion =3D &c;
>  	if (atomic_add_return(BIAS, &de->in_use) !=3D BIAS)
> -		wait_for_completion(&c);
> +		wait_var_event(&de->in_use, atomic_read(&de->in_use) =3D=3D BIAS);

[Severity: Medium]
Should the condition in wait_var_event() use atomic_read_acquire(&de->in_us=
e)
instead of atomic_read(&de->in_use)?

When remove_proc_entry(), remove_proc_subtree(), or proc_remove() calls
proc_entry_rundown(de) while another CPU is executing an in-flight proc
callback, atomic_add_return(BIAS, &de->in_use) returns a value not equal to
BIAS. If that callback finishes and executes atomic_dec_return(&pde->in_use)
in unuse_pde() before proc_entry_rundown() evaluates the wait condition,
wait_var_event() takes its initial fast path:

include/linux/wait_bit.h:
#define wait_var_event(var, condition)					\
do {									\
	might_sleep();							\
	if (condition)							\
		break;							\
	__wait_var_event(var, condition);				\
} while (0)

Because atomic_read() is relaxed, breaking out on the initial check neither
takes the waitqueue lock nor issues an acquire barrier. On weakly-ordered
architectures, memory accesses performed after proc_entry_rundown() (such as
freeing or reading private data after remove_proc_entry() returns, especial=
ly
once the subsequent patch in this series skips pde_unload_lock when
!de->open) could be reordered before memory accesses made by the proc
callback prior to unuse_pde().

Previously, complete() and wait_for_completion() unconditionally provided
release-acquire ordering via the completion waitqueue lock, and the
documentation for wait_var_event() notes that the condition should use
smp_load_acquire() or a similarly ordered access so memory changes made
before the condition became true are visible after the wait completes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D4

