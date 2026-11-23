Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9032D606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AaLVXHtb
Received: by kanga.kvack.org (Postfix)
	id 3E2EA6B05D0; Mon, 23 Nov 2026 09:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA686B05D1; Mon, 23 Nov 2026 09:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0266B05D2; Mon, 23 Nov 2026 09:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 090196B05D0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:19:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66A66A0915
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:28 +0000 (UTC)
X-FDA: 85466591616.30.2F239EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BC3A718000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AaLVXHtb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443566;
	b=Mt3a/jYMlmwB8DJCKSl8fxw3n+8dZLzdfpFXXmBltSqiN06HxGNXSRM0fRltePeH7jfoLn
	JvO9jJGYFOcLfFl8WFnsdHzcAZppe0O2jjfGPPXUHXK/hoC1S4kZDuiWK5O0MuBw65Glco
	UWULQAq7uMCbwPdRxF/EqPBpI5Wu4q8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYUmmEAb22LnKFiDajxYM3OVr0FaSmECDdgEbAZ9rAE=;
	b=UDV03Vpub0ix4F20/zmVjOaphry0kW24Iuc39HbQL8mj6p9lmtZ2m8f+WuL7h3gSlg1fl0
	sbUl2qpvBWEyDMnv4WFTBbsUYSeXcdVJJmaWRMfBy61SyLWXIvEoLcT5AtE4+Nv1deyU+x
	KDM9BuDI5IYwcXz89jNQVL0/UC923dc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AaLVXHtb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9C79444CE;
	Mon, 23 Nov 2026 14:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB2B1F00A01;
	Mon, 23 Nov 2026 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795443565;
	bh=GYUmmEAb22LnKFiDajxYM3OVr0FaSmECDdgEbAZ9rAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AaLVXHtbhSoF5Kp0N7n7e1/qzwNIKpxRTRfbxy4X/KCRSq5u0Dm7EjcZ2MeLid9BO
	 YD4Ii1u0BRqi+IHBl35rj2kTDey1hEBSDKuESK941QQS5xjXXjV1eq7sVsb0MYTmL4
	 q5ciDi+Dllfw2U2vISzGBs9dXwNgEmsibenM7OqW4ZcSpIqcM0k2C28rztNb/qIE/E
	 T/+Px2OaLLuQ7KDeo6/bDFQkvIqDwM12oFhqvDXSj1wfhjpWbQ/Gg9NirHzS7hRsPG
	 By/Rm52+U9rZkwyhJQzJjgl8y7rlGW+tS3jvIbiJ+6RVmBu1fL4RmPTXAC9XGWHP0Z
	 UvlsaiSK88xog==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: vbabka@kernel.org,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: kernel-team@meta.com,
	urezki@gmail.com,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters
Date: Mon, 23 Nov 2026 14:19:18 +0000
Message-ID: <179544354578.3575060.11576418215536505542.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120083707.296481-1-zhanxusheng1024@gmail.com>
References: <20261120083707.296481-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC3A718000F
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: guoudorb4tzuyx9tzemy6snfbckzafih
X-HE-Tag: 1795443566-411887
X-HE-Meta: U2FsdGVkX1/tUaF/c0IE5WNOBFjlb0CFtWW6bxrH/xrW1AxJE6BEZ5KPvs4bEBfzsYPRn2lbCM7BZve5njjCsz/Km8iH/ZldDIJ7iHpz8K0Ka9N5NtHemfe6sNW23yY6T86+Q/9XYz3XygKx5zbl4q+6ThFQPJpj6xcMANIN1BnqByD3c8gFfZcrmHxRk8FNEcxynnqyGHYr1K8UsnbEvpzEmU2pHkx/1mSy3vHxNJildaafwrs3DPo9QMoVUtNJhN1+ZrZN/K3v7KTHFrkjxkbnxndvSl2r0Y68bKWtvTAxCpsVHub+uzhFv2Tj3oZLKhBZKwXMXt+FvNUKnsVBKW4W9LDuEw5vVkrLb4tyPFndFMX9RrScTkkS2xMoyw5MO/x1PBCVQBEgadpE7TqqSwU9Iv4FyO4IzjJj+halpJbMcx2p3W3DnAi+3Oo+7+L0sJMl/ULIC3/Sv8c5U8Wm+tqSfwp1fLefGy4bUzmQV80q8d9tgaipRhy4uZ36EJdkpivNZs+P/WkzEJotdZQrXBdTXhhHcU+faekIjQCSOz+klaqSl7e6I/pP4YKNBr3br+b8ONwnltA812yXfWgHjGA0L75jkL3AbosqQQw2JE55lWhWcAOr1QzupZZXeAlElGwkOu1T0dBx/zY1vSNDeHovXzJSFl8QufBov328jHG3PRB4tytZJjwDKerXBI2gbQP+wFbWf3uGBbwfePBFojBlfuhMHP+uBD1q/ZWGkEBBiL4sEZ0dDkbUe6lefwYyHbHX3jzAlZ+eOJxu0Y6jwBmc5p8Gc/KqEHJUubUiHl1w+EjhoeWt73UYW3XwbofJ0ohMqSNI7S74nld4EXH+As3IwHe0nL1kR/gGuHHk9hWfs5qqbrnSfG36g8Zq48xKU+piGGlCVI+1/1r4bbZZbER9Z4YNIbXRNEP7VZRfuR18pdY5Ep0gCQ76qtiLK83oL/3C9E2uk3QpfAZ7vzW
 h5/rJWsL
 Sq6/MLFBet/z7JXx0Ir7FlERRJ06ASQixjZ83biUTkoNkWlept9jVwcjsEFUSKqynRnzUZ6Kb9DnoYE4/PzHAKV4bCp09sQSTOlX7wWH1KBoBZ6OUct2tEbcyw5QVA5oMc7NDCELsfqtVB2HyOhyrKf8ChNtCrZMBBU8vpbFe1l7iYnJay700JpclGM0O84zDOaUEzJII4/CtG7A+xhfcAa3l04a1onYZNFNVXVH/6bY1V4GJTMpVFVvGGkNPnwpHWdVW9Ko+V3JFGyHmFSRCQUEu2+m9YYV18VZfdg/z4G5ifJh+aF1zqwaDrrqQioIF/ytJvfMFYsZ+M+cEl+szIyIzbQBxDbgFiyoTq6SyqcPX0tnyOIAiX0R0p6Wb2k+G700y5jWkDm4Shb/clqEtunXRVcHhwkkfAF4I53dgYlUwH+GZGYhifjmllK4X6pgunQst8PJwTWRsPYC/26mxiNurwEp8kG0mueKKYYLCj+lCEYCCaKmZ48rT4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 16:37:06 +0800, Zhan Xusheng wrote:
> The move of kvfree_rcu() to mm/slab_common.c dropped the "rcutree."
> MODULE_PARAM_PREFIX, so rcu_min_cached_objs and
> rcu_delay_page_cache_fill_msec became slab_common.* and the documented
> rcutree.* names are silently ignored.  Restore the prefix; the
> slab_common.* names, never documented, stop working.
> 
> 
> [...]

Applied to mm/slab.git slab/for-next-fixes, thanks!

[1/2] mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters
      commit: 2197ea27ed0ff25cb294a3e6656ae6e0a23c8efd
[2/2] mm/slab: don't queue the page cache work under krcp->lock
      commit: 0983f88e2d6d734dc35cd9ba4f4c3b4082555024

-- 
Cheers,
Harry / Hyeonggon


