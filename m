Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA18CCCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9708E00D6; Tue, 14 Oct 2025 05:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199F18E00AB; Tue, 14 Oct 2025 05:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6C18E00D6; Tue, 14 Oct 2025 05:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE5E88E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:27:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9962C88671
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:27:35 +0000 (UTC)
X-FDA: 83996192070.08.7C4B5D4
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2CEA440003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:27:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cMZi+K0b;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760434053; a=rsa-sha256;
	cv=none;
	b=i/lZh3Dskr4k6hpgw/dIZydfO5wOSYBKUiMwGT8CPOAVcYwqA1OcRsOXklILv6vYTiiRzr
	nBOYV/ZNJP9YCjsY/RHjDpVmHmqIg182nZYuUFh0/3CEElzLLOi53EhELFn2umK8hxYZnY
	JmiKCDbxalDYTxp25YiGaGyPe9Ep5sQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cMZi+K0b;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760434053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9p0qTVsaA/0eUuNDB2HEIbJ57T7iM2pq155kMAVAFzU=;
	b=t9JJHtfrdLjE6eucmEB33Heznhl0zOSpnPLoDnFWTtau5kEfSsaHXXD0Q+ycZhZIP7bp2U
	uV+msVIv73MnZ3CFG5hJJciFuXrHqZyFcda2teYERe4HvDNQ1WWoJjkvxYAwL/Z024HcRB
	UoEaCC0AUlzy8xGetas4kTahy3jY4+w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760434046; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=9p0qTVsaA/0eUuNDB2HEIbJ57T7iM2pq155kMAVAFzU=;
	b=cMZi+K0bMqRNRS/rFSgN7U6MB0rDTgD7PV+O9mVaY2v/M7/YcS0l7zuNBBNdo5KjCNsFTTiN5PFbp95wF2Ivc+pHj+VJ4JtWRktswfQ+giB7F0gXikJRQsxv91zF0UTzKIb9J/lp8jlrY1afAS9aMclp6lV0LH5co60H9CfFvzI=
Received: from LG41624401116(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0WqBV2FQ_1760434044 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 17:27:25 +0800
From: <yadong.qi@linux.alibaba.com>
To: "'Dan Carpenter'" <dan.carpenter@linaro.org>,
	<oe-kbuild@lists.linux.dev>
Cc: <lkp@intel.com>,
	<oe-kbuild-all@lists.linux.dev>,
	"'Andrew Morton'" <akpm@linux-foundation.org>,
	"'Linux Memory Management List'" <linux-mm@kvack.org>,
	"'Huang Ying'" <ying.huang@linux.alibaba.com>
References: <202510110050.VG9YKMRK-lkp@intel.com>
In-Reply-To: <202510110050.VG9YKMRK-lkp@intel.com>
Subject: RE: [akpm-mm:mm-new 114/114] mm/vmalloc.c:191 vmap_pmd_range() error: uninitialized symbol 'err'.
Date: Tue, 14 Oct 2025 17:27:24 +0800
Message-ID: <003201dc3cec$c0697f40$413c7dc0$@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKp7XLvs+TopqcS+NXWteQ2YS1OxrMl93cA
Content-Language: zh-cn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CEA440003
X-Stat-Signature: 97gx1j6edsrdbk3ygth5rmf3p4er5zi9
X-HE-Tag: 1760434051-476340
X-HE-Meta: U2FsdGVkX1/Lss1VQ6C52yOoeGz7+Xhb1WeX1pb26immnNl2qWrZcurzzDnV4vFG0HGCVGTB0xMaFn7XFaB1RKV48K4BNXyL2tTy3dOj8Bh9eVTjioPUfzshH60w7wpEqGR5SN2ygEkBldur5r+ps3wHwQbsch8D+gUuM2eHr9WwcE31PDMBBBMsT0MGev32S4NxTqrYBViKYt7/RNNuCobgCMuf/AzfM1l1l+HD3RtJTCugvyhC49m7a99ymtAva2pxZc3cVec45rdx/Ht17iKjWtDGdIzAv+k5L3Byd2f8WIWCNlwpDpZ9vJEWcQGYpWCMLNdhn2aSarHHdGXALrEtJQaXrO6bPB2DTEmP3pzNYtPQZigPmyYtyUqNvA/rmMeKuwtTP5qpQVYKXdFgP7XlInI/VhTboLKl/DYoWuLDVDhaDFWTzmxgW835yClYQLDqiBLcfqub3WMNOrAUGljMfwVTofOkpXvASa4RLXVgC6Y0eYBA6dO9OC1n4MZdTipW5Mr/fQt2K5pKiWmU8I2nzaf4N1lWJpzu81v6v2aMuEQwKSOR8J5dXcqx9DdKhKfBvZHN/DnaI4w6pXg+1EoPlg9HJPPmv2GYMh8/sJc2ftf9UQrkLQjTGP5BhbxZZ9cFXu6XAwNqQzv9ufj/+vw61fHyiMN/7Wcw/Muoq97ks5k0absfx3XFOqX1aQtls86tNnzBNnoSoELrk03TBQoirBQEEB4ai2Qll/mejOr1F6Biz7OvUFIj8E/hg8sQ4uID+biDfmEwhrNs5aNAVCCAxbR285zsWQ5fXIZLknY+pJvqasGPPgchiXAGTC28SWt/gak41bZ7cxSYQunc/d9CqQnxTqV4QFwSBXon/lSm0OWsZYj9UGs1iu4cm2hwCcO3ajyEsJjTtKzzt082EHSbP0Yb7m9IvOSHmjmqAtx7L4aGpBydDcrP1CNpgDQc2EFMzS81kDS1MUF4a42
 NBe/RjAK
 QojUcnldudh65+rRvy6v5ATBwEWMoge1v6tCSfI9zgtH3If8nH1WmgoINyg3GPCJdpZN2y5maupQhm+W+928CTZi9ZlfzD/WwzWmGd8SH3tWeFCmQjPNRNWzoL0v4oO8/6Hl4R228OGhcXjwVj+CUkcFrmITdvXHLpet6vNKfkelhy/hBQi42n6vTV/qgm9zm9Q54bIEB3pfgT2Xo1Lq3BdDhjlC7Hodb7mgx1Q/Vs0jci58CjnTaobf6wJiJOK09ws7zrEFXq3rayz69Vj6cG0bSc0o/UCZUd1HUwJVj/jksmyKPwLBkQ3OOQin5ZOHuTq9Jv/7HvHvaqj5DIIpXTbRVKXQDIG3P+KX4lEckU6iOVf5sFZvwMfpPzRzD3Gbrje8XdHU3Dt16GRXLgs7HSGXeFJE7LWEP9qKlu+umAiXYh6mS2ISQKE1+H4H00FivNaNLc3xjRvBBfXaRkH0sRpKaNPGP1D/O6Oxh2eBjEKOWw0jr5Y18rBrUy1KU1JIA4oywzs2YTQWO+YQEOK2bU6IpiLKHftf7xt44yOXWTSDBtZ/VjhZkQzfvUTmmsdnPKyODHUWmcZsPj0xwRuuguBdifw6lwGPik0G6kcLvLYZyH92UNLalbJa+zKUAYH21jBm/AWGaUPs3ptseSuHXi7t+BA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@linaro.org>
> Sent: 2025=C4=EA10=D4=C214=C8=D5 16:28
> To: oe-kbuild@lists.linux.dev; Yadong Qi <yadong.qi@linux.alibaba.com>
> Cc: lkp@intel.com; oe-kbuild-all@lists.linux.dev; Andrew Morton
> <akpm@linux-foundation.org>; Linux Memory Management List
> <linux-mm@kvack.org>; Huang Ying <ying.huang@linux.alibaba.com>
> Subject: [akpm-mm:mm-new 114/114] mm/vmalloc.c:191 vmap_pmd_range()
> error: uninitialized symbol 'err'.
>=20
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git =
mm-new
> head:   dbf0247637dd0601a462793035bdd0b416b30e36
> commit: dbf0247637dd0601a462793035bdd0b416b30e36 [114/114] mm:
> vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
> config: sparc-randconfig-r071-20251010
> =
(https://download.01.org/0day-ci/archive/20251011/202510110050.VG9YKMRK-l=

> kp@intel.com/config)
> compiler: sparc-linux-gcc (GCC) 8.5.0
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new =
version
of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: =
https://lore.kernel.org/r/202510110050.VG9YKMRK-lkp@intel.com/
>=20
> smatch warnings:
> mm/vmalloc.c:191 vmap_pmd_range() error: uninitialized symbol 'err'.
> mm/vmalloc.c:243 vmap_pud_range() error: uninitialized symbol 'err'.
> mm/vmalloc.c:295 vmap_p4d_range() error: uninitialized symbol 'err'.
>=20
> vim +/err +191 mm/vmalloc.c
>=20
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  167  static int
> vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  168
phys_addr_t
> phys_addr, pgprot_t prot,
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  169  			unsigned
int
> max_page_shift, pgtbl_mod_mask *mask)
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  170  {
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  171  	pmd_t *pmd;
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  172  	unsigned long next;
> dbf0247637dd06 Yadong Qi       2025-10-10  173  	int err;
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  174
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  175  	pmd =3D
> pmd_alloc_track(&init_mm, pud, addr, mask);
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  176  	if (!pmd)
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  177  		return -ENOMEM;
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  178  	do {
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  179  		next =3D
> pmd_addr_end(addr, end);
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  180
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  181  		if
> (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  182
> 	max_page_shift)) {
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  183  			*mask |=3D
> PGTBL_PMD_MODIFIED;
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  184
continue;
>=20
> Is it possible to hit the continue on every iteration through the =
loop?
>=20
Yes, this is an issue. I will submit an addon patch to fix it.

> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  185  		}
> 5e9e3d777b99aa Nicholas Piggin 2021-04-29  186
> dbf0247637dd06 Yadong Qi       2025-10-10  187  		err =3D
> vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, =
mask);
> dbf0247637dd06 Yadong Qi       2025-10-10  188  		if (err)
> dbf0247637dd06 Yadong Qi       2025-10-10  189  			break;
>=20
> I always feel like these are better as a "return ret;" anyway.  Then =
it's
> just one line to read instead of needing to "break; ... return err;".
> Twice as fast to read one line vs two lines.
>=20
I prefer to keep same style in vmalloc.c.




