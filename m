Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A32606A33B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y23/HhZ7
Received: by kanga.kvack.org (Postfix)
	id D30DC6B05BD; Thu,  5 Nov 2026 05:44:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE27A6B05BE; Thu,  5 Nov 2026 05:44:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFFF6B05BF; Thu,  5 Nov 2026 05:44:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97C7D6B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:44:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A96071C3D7C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:44:19 +0000 (UTC)
X-FDA: 85400731038.16.9383E20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A4DC160007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:44:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y23/HhZ7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793875458;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3izgDCKY2tKTrzbElOHUZKuOJR4wxYIvmok7YVL8W0k=;
	b=pVu5IEukF7kMs99zFDPUuShibTEA2z3h53UKUgAeAcZxI8A62KH/oqd3XsNaVEWHXWT9ee
	K4fQBEADBgvOnIQN46uDglUTodUlr/FZuf4Uig+nQh9+7egEn3zY8u2M6tsXjBMTmjBNvT
	Zu20U/X0guMM2hS8/hgUu4haZ6GFsbE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793875458;
	b=D9k+7bYrnQqBW+3gTkfprtapA5kx4FbzJ0HyEYo0k3sudSBevpOc9c4OFzAwjUCYL+3wHO
	tlhH2dpnuY0YYm+NrXeuZhPaK0PpNeTA5kCWtNx5MnkEasTl0NgWwQs9drI/9j4Jg4NIrv
	iU7QSCVYbFokKS5D4ZnKPwWZ4S+0LeM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y23/HhZ7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50C5F401ED;
	Thu,  5 Nov 2026 10:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BE71F0093A;
	Thu,  5 Nov 2026 10:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793875457;
	bh=3izgDCKY2tKTrzbElOHUZKuOJR4wxYIvmok7YVL8W0k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y23/HhZ7UXBidoMrZf7HKqHWlD4mwne9bc9RuWU7EGUfnINFZU1JUgeXBwApx5+Qc
	 KhGmKBaHLuhNd4eAtoKGwrytm7NlfwXeMnUw8Zd9IOr9c4nM2tdJNlUek0ZTXUkxYP
	 c//Hxl8uCgo3Cq6TPYJ5jesVkY80/+sALbx9LvV8p0oqb2vyopu5BRHGfXSJv7barA
	 zsb6y/WK5lbQsDwAvO8y3MNGer5CgyzujN7ehY2XV9xSucK3F6jFzpiT5TPFqcrpa7
	 4vRfU63ObTeKfQUmh/q8IFlfFsNI9W0sBxGjnJXP245IxvZWsIJsNv/GoP4xcJHLCB
	 z66AKYk9aD5/g==
Message-ID: <sashiko-outbox-198875@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCHv3 bpf-next 2/8] bpf: Add user memory kfuncs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>, "Federico
 Di Pierro" <nierro92@gmail.com>
In-Reply-To: <20261105102343.311331-3-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
 <20261105102343.311331-3-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:44:16 +0000
X-Stat-Signature: m3gfsrmrgtm3miuooqdrui1twntygfxp
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A4DC160007
X-HE-Tag: 1793875457-678633
X-HE-Meta: U2FsdGVkX18bNNFnDbUa57k4VRtwoNqUXGKBWeIU8AAV4+PN/KX3acaqZelmywLi7WvsE8bGTBe2DjcRgM7/oWJ7qkLLdRUboZOXRXpj7NwPeNbnCLa0IsVidw34PkiGFE5z+HvZbof3aaeEjNuYDmnX2T/Oy7B1Vdq71LyKrua2L+XGtUO3BeQXdjX6jRc9ZjMXqvrb4S0IfRUjSaK5arS3S86Pl2D1nVbk13oGtZpSg70jnaaad6umCsqG8xBlu5BDta29QxK5tkvVvCU7Q7PevYYdjhNQ9xSl1LMkaxxac64bTUFOkY0vhM3mGTt9cxbxW3gJw+6ReLcfMDYGlr/v7DPpZL1ClN0CUTRci/v2a5tcqQMt6VhPTACZya/1byTB3m40nDjrT9L/waicpcbROQpShc2GgN8r+rt92cVFZI8SfWZkEz175eX1bcFkavRh5+uR+kf9QNAucqs+/G5cKF03n3jqhuo6oS6yCi0RCqBmeFbqx2ouEqg6YfFCSoqMWg8FaUCDDrfGv0PhsmgVBynzymnlMBqeFz4HHmMjygRYPxQdex/FkigsJfdw97qerEht7yQ82mLfpnpFPgCSfH5xPU2wy/92Go7QW6wvpyoPbozDoDGg/DhWSb0MwhTJUBsxw918zCRmZJV/63uzqI7LraMNYjM9sTZvgZSKak7JrK0NvbbET1eT57p75pY4KEuQ42ME67GnXC4mT+XOxj2Hel7LQymxzhb7lKBI/jjRj6lhak76ZxDrZ4xIYZNWdo4mUhlmXNa+SHcGU7kTv4AD9syc8I981Ly+KePFHu6/wE40YRjUCpU9PP+/MVt9ci8MfnhnTCT6vzGjBzFm8UFjv4fUM8MsJQ/3fwZjscExhZ0IzuGOnjP2g+x3mP8b/FuicCseFvDoWx0mxYmwJUDj/XMaFbzDLBDixpVCXBSB5awreepegWCEkH0KqXuKe6YDbzqBo+gcALh
 IhzUJTka
 usMBzK+MrvZKf35+8A06S1TDAMMQDICQNlQ7yh6kDZNlJi/SstO8HsmJYQdpgeSn8tiTDTkiGZWP5tt1lNhPgPcVDaTOvJAIv1AduiqhvoOc85/E9V2OjxyUDZfTFxwc3lIGnUYIAb7BQzeXQk+6ZdrtBGERfenvjDepJ1c/yl9ErwNUfcJP3E27h4cFIqQzVTtnEhco3skiZAbifQ+QPLf4w1XJ2X7ooRtvGNYOWAfxX/VCNSRnTRdDQg028W3d+0O1dzOkTRzBWi5dQ+ta51GhP6W89bnttsZthLpnLUWv5lYtHHAUgmyKpATCSB4GykOQBwUoKHoA/wS196pVnu/4B2JVznl/tbM5piFpgpc9wGrbqV0IYUJ2+CMt8rwP1j5J9bGM7Z7az+K3UVXBJY7dM+R/ufmdZLKOijOYwIMvJv1/JDHQPqCZA92FhgnVgWSxpZA+E3CrcqIcZoH/JUK2SeM3KVJ/vAyvp0Cbl/XzJK8ZfswaUrgH3otI/V5oqaNn+itqEMXlPnlK110bt7qNBvLfJ3frTRyPo1RvK/xEdzS5G/SFRdQ+GvyGXmBxTzQBz4XJu7X1H721x30bCk+ADwQFoXPb/WhnnStDDLrbzFZEwust7pBbAqaB8NrhfIBw/FGUpLgdD7h0c7oUPBpyJARzGXlbfjlge
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
- [Medium] bpf: bpf_user_anon_mmap() triggers false in_32bit_syscall() on x=
86_64
--

commit db9c75bc63d6f183a3894259aadc59e0c0a612de
Author: Jiri Olsa <jolsa@kernel.org>

bpf: Add user memory kfuncs

This commit adds the sleepable bpf_copy_to_user(), bpf_user_anon_mmap(),
and bpf_user_munmap() kfuncs for BPF_PROG_TYPE_KPROBE programs to manipulate
the current process's user address space.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 6788489a2608b..937a0d7d68390 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -3768,6 +3771,88 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, u=
32 dst__sz,

[ ... ]

> +__bpf_kfunc unsigned long bpf_user_anon_mmap(unsigned long len, unsigned=
 long prot)
> +{
> +	if (!bpf_user_mm_ok())
> +		return -EPERM;
> +	if (!arch_validate_prot(prot, 0))
> +		return -EINVAL;
> +	return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
> +}

[Severity: Medium]
As reported by bot+bpf-ci@kernel.org on v1 [1], when bpf_user_anon_mmap() is
called from a sleepable uprobe or uretprobe on x86_64 with
CONFIG_X86_X32_ABI=3Dy, can this falsely trigger in_32bit_syscall() for nat=
ive
64-bit processes and restrict the mapping to the 32-bit compatibility addre=
ss
range?

On x86_64, entering a uprobe or uretprobe via an int3 trap or via
sys_uprobe / sys_uretprobe sets task_pt_regs(current)->orig_ax to -1. Under
CONFIG_X86_X32_ABI=3Dy, in_32bit_syscall() checks in_x32_syscall():

arch/x86/include/asm/compat.h:
static inline bool in_x32_syscall(void)
{
#ifdef CONFIG_X86_X32_ABI
	if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
		return true;
#endif
	return false;
}

Because bpf_user_anon_mmap() passes addr =3D 0 to vm_mmap(),
__get_unmapped_area() calls arch_get_unmapped_area_topdown() /
arch_get_unmapped_area(), which invoke get_mmap_base() and find_start_end():

arch/x86/mm/mmap.c:get_mmap_base() {
    ...
#ifdef CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES
	if (in_32bit_syscall()) {
		return is_legacy ? mm->mmap_compat_legacy_base
				 : mm->mmap_compat_base;
	}
#endif
    ...
}

Since orig_ax is -1, in_32bit_syscall() (and in_compat_syscall() in
__thp_get_unmapped_area()) evaluates to true, placing mappings for native
64-bit tasks below 4 GiB and failing with -ENOMEM if the low 4 GiB range is
exhausted or len exceeds task_size_32bit().

[1] https://lore.kernel.org/r/571f32a410a85199bc9bcecfe07a9a9b6ef425b205264=
3e64031dd246c13691e@mail.kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105102343.3113=
31-1-jolsa@kernel.org?part=3D1

