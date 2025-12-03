Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110C6D1CDAC
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8E26B002E; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8FC6B002F; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397BC6B0030; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 272186B002E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3F1D5B67F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:39 +0000 (UTC)
X-FDA: 84179756598.06.A72E13F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0B27DA0016
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lgfupv1T;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764804638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Mho2y9eNn4Xh2fW5Ei8exNQUI5PMBFsU8PI55hOiam4=;
	b=ckCsyPMAHTOvZ8oyNaLRlGQ11bRYAZ1SY4F0zYkwA0ko4VInn9sKakYQceHU8vzU817+ke
	o3i+2gnMUJH5jB+hOLKH4Ojcwlegf0l+lOxzAlqcB55DxrS46locL4QQuYtA/d4iVuAXWK
	pWvd5+Q8/+ihOEkPgXCVTk1OYiq36LE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lgfupv1T;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764804638; a=rsa-sha256;
	cv=none;
	b=YR8ynGtsFyIyHk3CLBPNHAKNdczoAQKunTo2DBuFMghhDt1zIc5UvL1MsTi7gOr1R/bg8N
	MchAGoDGL6GHksPQ/kcLf14pdqGJO92dZ3CHswN7y4cE4CaMMS4BPTikG9OcyZyIaO20mn
	IJkxFgujzDCQthGOBidNbf8ryHpmkEA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B4776017B;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057EDC116B1;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764804637;
	bh=HNYogr7zzJHRiNSelDmcEoExR/fm7KJufnOedN0KEbY=;
	h=From:To:Cc:Subject:Date:From;
	b=lgfupv1TvQXvNqeGjsEp7Tb7NgOU0e+DsX6CLfuR9wVEbBaot1A4klXIvr5ctcExL
	 T3s+zZcGsR+OygeA2G0H0Jcb5gyzD3sc+kYsRU1v0RDskISoueDITyehiu+9jMs9Lc
	 HiGtzFqNOmXcKDRk5jVNUJJ0DF32fEJufg7vi4ZDsW5c/kmj4bqCS7dmON/Z/MJqSS
	 46Mg4VjxhHc2XaO4nxnFte22hvLB8hcds5Xqp7zmHecQdT3IsC8/RKCP2veY2R2o88
	 1Hyxj+kY/enbNebz4HmPBHZUCSySE1fjG4JT4z9zFlfHEzdt6m7SNSDqJw4APd0V2G
	 sHr32uf/ljdRQ==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>,
	Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v6 0/5] asdf
Date: Wed,  3 Dec 2025 15:30:30 -0800
Message-Id: <20251203233029.it.641-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3399; i=kees@kernel.org; h=from:subject:message-id; bh=HNYogr7zzJHRiNSelDmcEoExR/fm7KJufnOedN0KEbY=; b=owGbwMvMwCVmps19z/KJym7G02pJDJkGJyT5pu5Ks/h+QOPslH9hf+v13ieZh7re8V1xsexwQ VbmjgPeHaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABPRucXwPy5dv3HRNqWknabV F04JHmOrszu2vkQlesHtjGXfzG1+LGRkeFW1IKtFP/nHGbssV6lXa3wjfdaunP6ktsrIQt3Efh4 zLwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0B27DA0016
X-Rspamd-Server: rspam02
X-Stat-Signature: uzjko1gtypixchowsc58sposnfqcunmh
X-Rspam-User: 
X-HE-Tag: 1764804637-763145
X-HE-Meta: U2FsdGVkX19dICHHk6duupHXJdp0aggLMONv3DkegGZkHuU147Ar21BlvKBSBZvduiItzvgKayniswhhoOU5A0+KjwjcO2wnDpK3MBCaZNT+LvWJlN+chNzybm/eEVIQrtQPhXtHi6NlKN1QA3e/6pqXaFp14GLl/pEtR8oWda6uBadUwNak205ldka/rV5PnfkKM9sC+OQxFlF9Kuo/qYII7v9YF0xz9MEPj/H9V0XLGlHqaWDcRd5QiY8cJ2jPPRN8HCvCQ97RmxxVjC7JQfTNAW3NHHYdmeiRIHU+H4soy4g/Gn/KnV7jcC/QWgbkUqvj9N8IQAi1XM8HhbiW2RpcyTn55jgZq0QiCyaqyE8Vyj9ydeuXnZasLR71lAJ8iWQI7iK5hA8QyJ9zr2QSZK7pL6PhLQqF93WXfNhhLk+6BWKnA5YE2wjYir9xBt+Q5A18VayR/0qX9hUcC9R/zXgZdI1xLGLNi3ZnvdmAHiqKisfvcYOYduaNfg8ixDopj49otJe+OgDJGfJjdxmWDPqYjiiGE/OUoPp33gEMZcO2D3nnzuxWiQZMIkQ7gEmt3R6e412x50osickS8/DcMSalxTohcckfPLVe3gH2NiFoZMdCNeTyT/6ZVcdZRtS/nnmNFN9YShHleEkd1gZn+MYAZJoYyXoIwNaZDtsNhyUr0jdpbKJ62RxPqaeVKYJsOiapMxmAotnyvsmhVR2c4XLAyPdJhOsBqf25CNc1xH+OhUB3bWc4+vsV6rbTUNcPXf8aMeZYbaqA+c5NEUZm7jc5cMNhKD9dTLju6hOwGKKSBhIIwiHyvDQZUlc0CIaipaELGosWVc4a6GNpJSAnAXpK86EZVhSMVNoocy9RabSKTMN1zXFwr81ne3koXTBZ4tRxta9otr1OLkpLosgBuQppZRfrgeoC20R78XmdVYU/kumOkJpgaQS7xD0fWlhPJUAWHFix9FFJEj4I95J
 V3kXn7jo
 zxlQG1NV+Nmq2qsOPGjiIf9jBcKhgFhNS0D297JTKI24oQh1+lnEeUkc8SfXJYm1WGVqdvJJKuIesOyjlaIu3AcV7Xe5XKDVnAB8xUhdP4oPoh8hamAknNXSvSJJuIUGSgxiqForugXrxEJIUa3nTXGkxrxmrFgKTFk4yixIwxTolNOAGS5QNUDevqg77DhFiAOZgAvJRpY5aV9k1TXC8Fpwgpn+IXjOi9NLW4/8li8+np/ziTAqRgL7N4Lp66GxDMNA98EhCxg4UMGN3u+CETYJnrIeOd6QP+z52fJNgtG4CoGd7NphmwDEuX3GhYJgmP4hiXSktlOKRTqez1d11SL3Xkfo2sd70R6G6jAKxIRX2u5wlYL7r5Ty9Zt0uowr697m0/fjUMemVcm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Here's an update for the kmalloc_obj() API proposal based on Linus's
feedback. I normally wouldn't send this during the merge window,
but I wanted to have it updated for discussion at LPC[1] (and here in
email). Please see patches 1 and 4 for the bulk of the details. This is
obviously not v6.19 material! :)

Replacing[2] all existing simple code patterns found via Coccinelle
shows what could be replaced immediately (also saving roughly 1000 lines):

 7971 files changed, 19880 insertions(+), 20752 deletions(-)

This would take us from 24515 size-based k*alloc assignments to 7682:

$ git grep ' = kv\?[mzcv]alloc\(\|_array\)(' | wc -l
24515
$ git reset --hard HEAD^
HEAD is now at 8bccc91e6cdf treewide: kmalloc_obj conversion
$ git grep ' = kv\?[mzcv]alloc\(\|_array\)(' | wc -l
7682

This treewide change could be done at the end of the merge window just
before -rc1 is released (as is common for treewide changes). Handling
this API change in backports to -stable should be possible without much
hassle by backporting the __flex_counter() patch and this patch, while
taking conversions as-needed.

The impact on my bootable testing image size (with the treewide patch
applied) is tiny. With both GCC 13 (no __counted_by support) and GCC 15
(with __counted_by) the images are actually very slightly smaller:

$ size -G gcc-boot/vmlinux.gcc*
      text       data        bss      total filename
  29975593   21527689   16601200   68104482 gcc-boot/vmlinux.gcc13-before
  29969263   21528663   16601112   68099038 gcc-boot/vmlinux.gcc13-after
  30555626   21291299   17086620   68933545 gcc-boot/vmlinux.gcc15-before
  30550144   21292039   17086540   68928723 gcc-boot/vmlinux.gcc15-after

Thanks!

-Kees

[1] https://lpc.events/event/19/contributions/2136/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=dev/v6.18-rc6/alloc_obj/v5&id=f79ee96ad6a3cafdb274fe15d3ae067724e72327

 v6:
   - Drop _sz() helpers and simplify the resulting internals
   - Split _flex() helper into its own patch to make review easier
   - Explicitly use TYPE within the internals to make things more readable
   - Move treewide change details into the cover letter
 v5: https://lore.kernel.org/lkml/20251122014258.do.018-kees@kernel.org/
 v4: https://lore.kernel.org/lkml/20250315025852.it.568-kees@kernel.org/
 v3: https://lore.kernel.org/lkml/20240822231324.make.666-kees@kernel.org/
 v2: https://lore.kernel.org/lkml/20240807235433.work.317-kees@kernel.org/
 v1: https://lore.kernel.org/lkml/20240719192744.work.264-kees@kernel.org/

Kees Cook (5):
  slab: Introduce kmalloc_obj() and family
  checkpatch: Suggest kmalloc_obj family for sizeof allocations
  compiler_types: Introduce __flex_counter() and family
  slab: Introduce kmalloc_flex() and family
  coccinelle: Add kmalloc_objs conversion script

 scripts/checkpatch.pl                     |  39 ++++++--
 scripts/coccinelle/api/kmalloc_objs.cocci | 109 ++++++++++++++++++++++
 Documentation/process/deprecated.rst      |  31 ++++++
 include/linux/compiler_types.h            |  31 ++++++
 include/linux/overflow.h                  |  42 +++++++++
 include/linux/slab.h                      | 106 +++++++++++++++++++++
 6 files changed, 352 insertions(+), 6 deletions(-)
 create mode 100644 scripts/coccinelle/api/kmalloc_objs.cocci

-- 
2.34.1


