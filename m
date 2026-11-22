Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA7B606A683
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i8SRVkQV
Received: by kanga.kvack.org (Postfix)
	id AF8FC6B05B8; Sat, 21 Nov 2026 21:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1106B05B9; Sat, 21 Nov 2026 21:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D826B05BA; Sat, 21 Nov 2026 21:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8256B05B8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:13:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E87580616
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:55 +0000 (UTC)
X-FDA: 85461134430.16.00DD65A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 88DAC1C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8SRVkQV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313633;
	b=jjmoNhj5mYBowGUYTXe0NLNGSLWLtLQMP6+L0xfOLP8KIirrxtnQvOUXoN31XT8YYW3o+N
	RZR2xXuEleRJ2i3hzQuJV3+zaJBpk4rsDycaEwo0QKj3kacPpone4eK114283vhDx5+iCn
	SHuTesPHchfzuz0sfHE7DoMWGWipLYc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QITS/QYva23ozmEaxii1esTMO7DrH16wtmaozkU9sY=;
	b=PAPl7C3Uq5j3+0CaoDW9iCg10Nm9bbll8vcMpXIHoG6aM3Z+Pda7PpM1c7ivAZhC/UU8iC
	iPdvgI7V9pnKjukyUyxKJnEOf0vxU+GBJAZ7rnnyT9jfyhpdhiCEVysk66LjOHUKgKDvod
	C0V7WWfPte1RkfGm9yuDmCokgDNNlvs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8SRVkQV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E53EF45968;
	Sun, 22 Nov 2026 02:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6314E1F008B2;
	Sun, 22 Nov 2026 02:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313632;
	bh=9QITS/QYva23ozmEaxii1esTMO7DrH16wtmaozkU9sY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=i8SRVkQVfMVUSOaeRqW/22HFBTQge0lZRo7DxOFvUpD9ypGTq29MRAjHTk6SHaO89
	 u6EN/oWjsUlxlOanYJ9itHDIlKZ5neQql1kEbhKM2sTHIM6+d/j2Nz0pU22v4W5rcD
	 dhmBZuK0OxEL6Y29d3M28n8tCwoGAx4AmH9KulxtBm1TMFDESvMWXeDgVmShNOY4hU
	 DCL37N7yglLu0K3JedUaPAHu2eihppaY6yfB1mP+5nlrj3yhBTjRycd3H7d9JGAS9Y
	 qNEkFhW7PWH6LDeM95M0kf0klzOjG2Tb460O6p+++5cQ3Vg0mGhjFnJzxLIv4+sZaC
	 XCLLsPM0e3Wzg==
Content-Type: multipart/mixed; boundary="===============0836080936566238576=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <fac042dcb631adc09d227a590d8790c36bf5aa71a7f047f7c07feef2cf8abc93@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-3-jarkko@kernel.org>
References: <20261122011809.2667684-3-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 02/26] userns: Add userns_set_idmap() system call
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:49 +0000 (UTC)
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 88DAC1C0004
X-Stat-Signature: o5ecuj77sw3rfbugw9sbbpwt37xodnpd
X-HE-Tag: 1795313633-346987
X-HE-Meta: U2FsdGVkX1/DVSIOfA8koN+jIqdaRuKbcX0HM66xOMkWqrsGgq/h3HAg6awqQSTrF6ixX+Tzb0/B3tMWrcDmYofFj4YpUJtXzNTwLX4Kcp6kh16t6x51d95D1RJcoyZIx3xHgiQxQosKiDKOaS5eAPy8L6vxVBHOKunCjBVtokoaMo3LQQXcSUoIuVzr/c7keQ+99wCuDKDMuFze34PmmOn/rU03n8DKLYCYVt0yS72c0VIFUylVM1AdNZuWuEnc6fWNpCFrao3OaT62Gai4dHMlH3uQ533MCn6f6oncMPNfvRvG1TXkv15xsBGxVwquRlV14LsCF/5PUaAQgNonMMYU/JXiSiJ3+R0/+XyfulcSwHfiyXvbPJvs408QaftPyML7j/by2DH3Zw0Qfovvgu7yFHmfm7YtHuM29Cqcm6M57KqfxmEkT2X3w2yVi0tEND8VUBIpH/x/73VsR0K4WOhFCx9NuH2ULCbXuYDY3AGGURolI86Gt75o3bO0wDfhiF+81FsZMiSs4bc6x16ZYfMdMp7bVMOVDXhmzpeWf1BZDhas85CUOzqtT6YMDckK/RmD4l1H9IDYxYl/ncXHxBn37UJhOxxDwuQcED22xCq01N/bHn2uP0/QTpwcPe8unCi13xsCd0HLF6tNc1CQLh408LvcjfTDjsI88QaESXoJw19yMpv46fd38341zp7Co1b5dI0XYunj5/AdjEz5Flyq+OjBWSkHgi5/VvfwdKxRiPgxPG3bfztYNAxKADv+Xv3h/mG0XWXccNVyTDdii5sAkhBT4yN2rMDTr11r72X40B9dOtrAji554dlB8+TEWPH9eBz9PU3kuPN7mxOT9kyV0O6zVfMN1oXhF1RGxYgQ7QTXgWQolP/UlvJtvvJuT32rTVgmIXCRHyg/YDILGFMTn/VUC2b+yjq/CHgIYMUaIV+bCqSdpDqpEm2vXn8VQDtXXCxNXuMoAbXlD9C
 1ss9xVk4
 cUesfAqstKnqt18c3KDEJfwsO/kx12huS+ZJZdY/lcJd9l3+tRRVQPA/t+bUZ2i/sxBb/j3xWRvc/REPh34DpV6DRioSCc/VMFV/J2Zr/LA+lbh++iC1D1wM+i/w1l9g1z8rlYI0X6XFuxAi1QzuY7IBtirZyDMdW6D33yn/9dYqUugYTpKQdV7Hjsz6eE/qDD/pVBV3Uquk63s2FuKqVeFDZqAi56VeaSCIGOz3bJ6/GQNenoJx0J9xUpb1Lb46ANWpElVwKpaxHOR3l2QauNxR3Rn7B/eN2FRSJwgCgoOuge+/Xu15BDJqRa7ujY1VK9uWUsl97VdSvZNGyvXlHZtn+Iib70vK62S89Bl1YfobpOREKxN4T4WMYCbwWzVnMzWjQpTWLsB74IjCjmTowMXmNDqemL1Ck5FTa570ZYRExrWL69lWlfCkxV1UXPTtoOUlnqY7Y2Ad40zwfwGXlhysMlUs1EScOV6WqwYSf+/g4hbAm2fvG0xjZCw8TygyOG1+G+NmsUZixpCFOjCDiV3Rz7+5eVl2Jw3l66wbF7mqSLgJdf8r0N3cqVpviOiu7X3G4DGr0qzIEyji3ElpIPFN3yHoHjJkO8gwZumFZd4gVnQgmOZmBmzCO3KwCWiRYc1zaQRX+LOz2UArofWU214Sh9SOuGJ7aEZlJQieCIPnNGOcV9es6NmIO20Gborm+pgCGyCgIlbn1cTwVE7PSS2vdXUjLpPb4AHAh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0836080936566238576==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userns: Add userns_set_idmap() system call

TL;DR: Design nit only: the new idmap permission checks in userns_set_idmap()
seem to duplicate existing new_idmap_permitted()/verify_root_map() logic; the
review suggests a shared helper. No bug is claimed.

> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c

[ ... ]

> +static bool idmap_maps_root(const struct uid_gid_map *new_map)
> +{
> +	unsigned int idx;
> +
> +	for (idx = 0; idx < new_map->nr_extents; idx++) {
> +		const struct uid_gid_extent *e;
> +
> +		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
> +			e = &new_map->extent[idx];
> +		else
> +			e = &new_map->forward[idx];
> +		if (e->lower_first == 0)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static bool caller_idmap_permitted(struct user_namespace *ns, int cap_setid,
> +				   unsigned long ns_flags,
> +				   const struct uid_gid_map *new_map)
> +{
> +	const struct cred *cred = current_cred();
> +
> +	if (cap_setid == CAP_SETUID && idmap_maps_root(new_map)) {

[ ... ]

> +	if (new_map->nr_extents == 1 && new_map->extent[0].count == 1 &&
> +	    uid_eq(ns->owner, cred->euid)) {
> +		u32 id = new_map->extent[0].lower_first;

[ ... ]

This isn't a bug, but the root-mapping loop in idmap_maps_root() and the
single-extent unprivileged block here look like copies of the logic in
verify_root_map() and new_idmap_permitted(), differing only in where the
cred (current_cred() vs file->f_cred) and the setgroups flags (ns_flags
vs ns->flags) come from.

Could new_idmap_permitted()/verify_root_map() and
caller_idmap_permitted()/idmap_maps_root() share a helper that takes the
cred and the setgroups flags, so the unprivileged single-ID rule and the
root-mapping test are written only once?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============0836080936566238576==--

