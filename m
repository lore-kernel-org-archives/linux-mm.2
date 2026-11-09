Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FB0606AFCB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJkEU9Rz
Received: by kanga.kvack.org (Postfix)
	id DC6E26B05E7; Mon,  9 Nov 2026 13:32:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D4B6B05E8; Mon,  9 Nov 2026 13:32:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3986B05E9; Mon,  9 Nov 2026 13:32:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A88586B05E7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:32:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39F52C06EA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:32:08 +0000 (UTC)
X-FDA: 85416425136.22.809F0E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DB1E1A0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:32:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJkEU9Rz;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794249126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1bx3cQBNrnl/+bVhczOhkj1gBe4lxwMh5p/lPOBHw8=;
	b=iXMHphGS1baRqPsNhoigvnFZ9UvIhZ6fmXFfTMKdu06NKNHN9Cm3xV8HgFuV+yTQsxeLUp
	JscZKO0QBuzKddMbgszo/Hnc8DZuZHmzsvasKxjtY8/2v4hr/NJbtkUabDSe6/UWjTep9M
	HRJk5tqhJJMbIeAbdySATpjoLa18SjY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794249126;
	b=iKgTD7Z96/RvDf8cJe11kSck1fWj2EZOvFsJYa6NoAnkhOq5uCjR1it2WWSQ2+Pc0hOSYo
	ttghbRcwDUwXfYLAqPqtGfBn4atW6jtc5EtC9GRLZSPAPQ0DyD51aRJ2/N/hJ+9SHMKAUb
	rDdHz7E5bOEy0NWKEh1iOpgyoqJJP1Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJkEU9Rz;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A093A44003;
	Mon,  9 Nov 2026 18:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CF11F0089F;
	Mon,  9 Nov 2026 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794249125;
	bh=A1bx3cQBNrnl/+bVhczOhkj1gBe4lxwMh5p/lPOBHw8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DJkEU9RzMtvmKZEhK4grAJp69GoJfavwGia2y6elsvv3/QPwjrXNjprT+YRhg8e0Z
	 WIvRQ5xlH2bDM01VN69+0ONW/Ielh37ZoYyzhlrXcvm/XbBPTyvhj2eLbQ5Vx2t+NO
	 4f/eMQYdSQP8Opmu22YX+SD8pGdb+mBm7+UpniW+T/ReDZiFoN52WuJuBTiLfzrLjF
	 l+yXgKSB12SWZrHdKPWG7zEBztfWvYeviTlMekgkuDCLwHCeXMTty4oGixEZOTGReg
	 bZT+5iJ/EvrUTplu/UnmcWxl0DkQ6LDGZgLT5GDz2cR8MAwK3/nXLJ+ESfUaPg8rGj
	 XgO9PSnKSLf9g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 09 Nov 2026 19:31:53 +0100
Subject: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 update
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
In-Reply-To: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310; i=david@kernel.org;
 h=from:subject:message-id; bh=C4p8LDMbx+ZkjajJ+iKnXRHO7ncfgEapbAI+tnp46XM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI+Cc7uWpa3WqFBat19o2T2C0prXJpXPrbllXrKFZDxR
 H9O0i3djlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACaSo83wP3uBXMe9Xd5ht632
 xJksnWS89tbt3s+7OtYqeG3a1VX3O5mRYdGkizLl536nPVxbMtkh03v1mtd2HfxRl1nPJv389Wr
 SK0YA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam06
X-Stat-Signature: kqr5stxpaj4tn13xo4cdzjik87mauimu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6DB1E1A0002
X-Rspam-User: 
X-HE-Tag: 1794249126-863711
X-HE-Meta: U2FsdGVkX18rEypbkgt+dg7erE9dhAlxwAaTukhiESfrmdkz//PXjzWJO88b4fYVMrwyZ9+fvRkLdoAuoJAyTRk9NRISsJkHmAZ2A8hcJDZoItlmLgQo+96o1SdBsSY0lbclb9Vz0ycT1/3WrEdsUW/zgICTQzzGHLIok1dG39pug92rCTVm6uTKzXUehf4kWrNQbdSJYWVqiGizzEkZsFViY1/pojg3RcEhin2s/AtB1CLT09GJT33AlAVax99GYgd//a7IYC1G/v0M0rJQ67KFdhquxeanYQ2AznCR/pAC0bhb9NsR7XMQCu8cGPPSeSRQjSbxreajo/gbMeJ1i64soTukGiqQZ3uGvtvo2FIWYNKO/ayH2ukijBo4Y76utMREMN+hsZKRHnJmKVf2daKm8sA8uR+GjqTiuBiGh+VtstsGXp1F/0sxVyhpcG8RXhwVntsJI0KeqkSqDHVXtCOxe0ixVaVGb7/Yslh+OKedHlgdeVbIMAX5vN35emWQr29Q2VMXhKeyLBfEivMYxFd2CKBBE0MYjJ3CH7XHWEMUVmYQvT/TssvJxv39QkLacf71lz9HOkjW53RVET5V0z0zRKGVd/SvDgdZVR4T918cIxkFr3FQ/qmNL/sMODQ3eRTKFcHJz0o7UUPHTPGkSYtj1qP/yhF/dEkQ3AtLmFoIreNa31pxmyjSJij1iTyWBXZ1kS8KoAp+1NQrJBYMyDCE6gHLtoxYIDVXBfxTY0QnP/Nle9QPm9/kysGoRElU/d1OzowiEt+hBw86uuC07X8Ue2IFaJsLkjq+jzQT2VKqJ8UUILi73Zn5BjAeYXKY2r1DUM/jNzgBTOCd71YnBdIajCGqOwaH3xKf3GdT9Zj1MOSTvR/+Zc7k8LTXUWJpVkgQ95u9KSMZ7WUeYMKameXzEeIbfhquPuQyQMQG6lnolCDAXnSbgt0bWmCI3be4+BiJ/4RwOeZ2mRBTWG4
 acoUC1o2
 SY5yh/xxU+C77RHks+ZkZXUWmoHnSMq7r0LPPTUXPBJFxvATLPp12J+qleZP+d5YWuOuVwaSsg2hws+3vNaKTDug+B8R++klBpuqsbSWCCZMG9mtnUoljhWdfPnrHtjYBM6uqJUR4Rum0mO3NRXcPNRdxQUSsOG4yFGVkO49TZHCgl1F3fbcMOcV6a12LnRCUjycZFFJFINA1rZOzuWBU9SOodmidIxsYnuU0BnJ04WEyT/T8VWirBHv+MzcaYjVBaUQGDsLHGgoy6vPMQcnFNAIGr0g4GNootaE+vEGzfh6tuRlZwG1XV83wcjcPdqB9ygF6TZ8ypjuyogCTQtzAiOKTqFnRuYy1OFgF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MGLRU is currently the only MM component without a dedicated component
maintainer. Fortunately, Kairui and Barry have been actively
contributing to MGLRU and have volunteered to take on more responsibility
by officially taking care of it.

Given that Kairui is already an established MM component maintainer in
a related MM component (SWAP), add him as an MGLRU maintainer right away.

For Barry, the idea is to transition him towards a component maintainer
role over the coming months, starting by moving him to the top of the
reviewer list.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 222b7fc2c3aa..e7ac319a570c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17635,10 +17635,10 @@ K:	(?i:vmemmap)
 
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Kairui Song <kasong@tencent.com>
+M:	Kairui Song <kasong@tencent.com>
+R:	Barry Song <baohua@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Barry Song <baohua@kernel.org>
 R:	Axel Rasmussen <axelrasmussen@google.com>
 R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>

-- 
2.43.0


