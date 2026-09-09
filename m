Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C6ACC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AEDA6B0092; Wed,  9 Sep 2026 04:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387186B0093; Wed,  9 Sep 2026 04:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C44D6B0095; Wed,  9 Sep 2026 04:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1220B6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:22:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37BDD8013C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:22:37 +0000 (UTC)
X-FDA: 85193532354.02.4AB780B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 51C0640002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:22:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQjuY8oY;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788942155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6oCYgINkfsNJqPA2oM85Ca7xOFugQPqnIa/px/TGX8=;
	b=j0W/s64kvtJpXXSiCszMMYxfdY4KVAa+j5YSmZ/sKf3m+YSap2VNQLV8zRsMfm9/J6A4lx
	Grdk1eoUBmZqnyUF2GZuFH4A7LkI1ddOwqASZtuVO5TU3fmRAU2L4l4X7cXCrnJWj60sFx
	obim8KBHdmwmBIBJYaq9VyUd2GfBAyM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQjuY8oY;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788942155;
	b=FGCstBPXUmwfGbUZrZXqT1DvSQsairqiJrXDpK/Kjo+jbwmmdo+POci3Trk0s/CJcFjAJt
	L21gWUSDKNCv/otPqIkumcpihWhF+10k4K2QVW1Vq17xwgFmHtrJS/Wrp2jv5yOeRqGOen
	ucxQtEc1ehjt5IzUeaLuHKeb0ET0hM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 79FE2601FE;
	Wed,  9 Sep 2026 08:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7FF1F00A3D;
	Wed,  9 Sep 2026 08:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788942154;
	bh=+6oCYgINkfsNJqPA2oM85Ca7xOFugQPqnIa/px/TGX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hQjuY8oYInGcV1So6iO9Q3CIQU6clKHndvvPv1jffB1dzdjrLhvxwkPz6AcFHAUUl
	 0KZ2JpJY4Ql04joXa65X9qpz20YYZOtvngPZgz/u26iltKDjTHZWPVmuV3H4mjJWUY
	 8l/fPctVVEmtawEeiB/10fZKf16frLsdWBnOvedocIOwPU9Yfb+E+/KBhcVdnzHaCZ
	 0j40glHANcRIZ6fwybjWbuxTAi2KTzKJs5Uvi7rYdKtRiRqDwtRZR422+KCtMvhqWC
	 FiJRoux0N7xfnHhyg50JtT+6uPQJeWpL/sW9mLw+7vaN9Gnw/dDkb26LVDPD+D9erL
	 8P7Mz0zkce9Bg==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id 248EE198004A;
	Wed,  9 Sep 2026 04:22:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 09 Sep 2026 04:22:31 -0400
X-ME-Sender: <xms:QhehaqC75siJ3my3rZDgROu8Yj7Fi8oN0INnIdTJgvrljY9WgW3h7A>
    <xme:QhehalXHa4GWm-0J2No7Dg4lWiH-5nq5lDSWHpulYyXBlH4tem6kz5hJsDQNxPwlR
    DvgwEpSHb-V8-XzV7bmw1QEk_dmvSn9R9sdFxffEhREshb356SY>
X-ME-Received: <xmr:QhehasJ9ng4r0OuXk_BakMPnnoPJqNNynaU2eKbiY_RL5XADNiEQ8lj9_3I>
X-ME-Proxy-Cause: dmFkZTEcTcHQ4MngkuVgRvgCf1pYu4WzUNsiawxGcilgXUqmQ1oG+l7QhW/s6HICWDIeEa
    PQfaB0zQ7ywHUBXBRzm3D/YBMjJRsDBA5TdAGDbETxCjzg0l5Xbtt12D1dHBki6qcPpAk+
    baB+GykBIXQo70A1drmvwTt8T6Einn/s6xy52G7NYFE7zenfgyWUCypXrC7Qliajo/L3bl
    zt+6zCRDD2YjDcJgxWmAhFN0P4D8A/0/SGnOOpqq/8cKPStit04/XdTFWg6ydCGu3CWx+e
    fHQV/89X7tINX+yQGiZkTrDYgZ7RNTM9zMHBzXwSVdQWovc7d+SIs/o6QZScLrTze9fADw
    R6WKeZ0s2YlrYyiUdLUH8rl+JH+DRd+ekFoZICNygZRtLCgshhNFyuRQe0jUlTeRME92MH
    jQjX4y0rJTHlpOSccrkkx+LKsoiz6GddG2Dgb6q9kR9ZXwWE2KOeZ7RDCYISAGtf9YAd7D
    BF4jJgSi6lJq4v4mDOSYNby7aovUqMDoDBFNTEH45c7HoJq8rkiCBH845zkL1Q69Hwedmw
    zYmWP52u5qnQp0mVmHOS2gk2rklU74savcw6OZ5AztuGT1dK9/hSO7bh4ROHDjQP3/n7r7
    cIUltSZBLTFtkadyfYKtmVew8LSWraooY++LqMArKWWV2XBW7u3z1JnP0ttw
X-ME-Proxy: <xmx:QhehaukD2Tp5l5dwOAvEQlis4BEGDdGT8gfqBlwbWggf6VQ22xv0cA>
    <xmx:Qhehaqbh6r14faa_etAg9k7HngOcTq-49i9HNDSj4h9kc7gF2NfabQ>
    <xmx:QhehaogorFOge6wZlg-yCI1OZH99aUQDbzeigCR59-WHl3BPE6HmYA>
    <xmx:QhehavShi3E3GgnLvs5tWxXTa_pJBn1wMKymklTv6BenQr88D-IOzg>
    <xmx:QhehapMkrk8SF8xwjQvIQysJ6FDoQa5-NufIQVn11HV3XUBYaZnSs_FW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 04:22:25 -0400 (EDT)
Date: Wed, 9 Sep 2026 09:22:24 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 14/17] mm/huge_memory: drop the unused do_lru argument
 of the file split helper
Message-ID: <aqEXLroENEmS9ii2@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-14-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-14-b532a3f20e71@tencent.com>
X-Rspam-User: 
X-Stat-Signature: qc7bhfdr5y398r7xue86knojt4cf4q8p
X-Rspamd-Queue-Id: 51C0640002
X-Rspamd-Server: rspam07
X-HE-Tag: 1788942155-889012
X-HE-Meta: U2FsdGVkX1+MI3DyPPXhdBcRBlvq5zrg4GD+9jhx218MGadTaxZjSvJPZXC3X/rjZJElxTXLmpLKBciUtCRBFkfWMM+dIZz9d6n6/v1ivo4u5rgeJiAjbddrGpHfwWtDBqE1DGIpDBDwHx3XMF5v2GtEULFFGbmJNgqP77tpkwVMdUcag4heh74dtIYT8Uutf1efqJFvSh5uJBqSLrzHIGnOp/4Kp61Hf/VxB+rO+EbB9N0DCs1Bl5T4Shl7jbplWybtpsPI+cFvX68tNI/krgW9EuyXPOPGAAxU3DOklBy/TPZhYc7PZLixHBdHQC3XZrphbGoz/ER+TYhRXoYUnNGQomQUHAhT6cWZFMp9YbC84CpL0PJSVu2y8OMS+JDNLka4UGbT3g6xenIkq+jY7P3/jnc6o2ambl1uGkRKk2e/XfUtegxFQmvIYNotRc/bXlYIos+GBlSMax2xMonY060RpjNCorSjhCcEamEQMKlCV2r2om7K3F03fN9XH9Llq8hVkQ1I6HKgM9IS/Xor2mv0VI+/+s9JGVIv9EFbbDTwg2HmVUauKA/i03R678cDRNWY7il9/DOlALIPTKLfHM48t64Z3SsQ0f9S/rgMV2JJsGb8NzZ4ZJAgqbV6DjjZRnjDe74XcV2cER99nQ/RKkepqLsPQouu7P2gw5ygzsT3cCzH5PvtuUSZZOLbb2Es4M9+O3w33SYTo6n7AB9D1txMW5bAbOp+pE6M2QG1wKDaN/2sCh/gauFPO09uoErqm/X8pEAOF2gHxKuEHDkRuq/2+5xRCHe+TkDX2NV7oOSoYrRBOPVwIKaQFWdWMM8uTfbduwsHPJlil03Ps/sQtsG8wvJTqGaPQKh99Okr391G2YHZ6EusnfxOaaKMYV4rnEpw7e6za0Pmh8whOk5jysPeyqYvWbP2edZFnNmLFwyACO+JmGVbTKCC2fUhRIrmHMshzB8F09kbmVCH/S3
 PfZRZWnc
 o12inayT6C0hIO/dplsDCqlBygCARCHinCHUbT/gX+DchylhZ33h875v6H/4HA8sQRvxr6AxCMtRQ1rImW3wrRnHG0lCUr2H+O+n2MMJIFkSZBzp0u0QahLiSe0cKHmE7VSO1l04Lbn3Eu5BWVhDZE5Uve6uzkRwF5ECYGrUNI0aff3JpbCTEYODHzJ78j8nFp/qaaTR2GWONtznt38kNhVZ55dCDBlC5L7X7vBjplu7rCMQRDIyEP4AFLki1kyFZB/8OaaYbt10Z1bupve98PNLOuHllsJGQg8GYHZ9vGQtMyr4dYL8Ek9RSNli8KdHrxObb5ApFOBKRyPMHKnEvXWfV32hUpjg3Ex/gbQuIcZgl5Nu5IE3KOlSU8+c+KCtApVia3lY/JBjwpDKdBbCcVBeJERQC0lqW0i2dYojQBzREnTulPpMwV3dxcFCmYjAfwgRODbeBMHZkFgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:18AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The only caller of __folio_freeze_split_file() always passes do_lru as
> true, so the argument and the branches gated on it are dead code.
> Drop it.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

