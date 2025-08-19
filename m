Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD19CCA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 00:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EF368E0002; Mon, 18 Aug 2025 20:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5FB6B00FB; Mon, 18 Aug 2025 20:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CBC8E0002; Mon, 18 Aug 2025 20:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DEC3F6B00FA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:36:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 725831401AD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:30 +0000 (UTC)
X-FDA: 83791640940.05.D592BF7
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf06.hostedemail.com (Postfix) with ESMTP id 77962180013
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="M fiOEYh";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=itIohdwI;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of boris@bur.io designates 103.168.172.152 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755563788; a=rsa-sha256;
	cv=none;
	b=RoIvrPu9/GxB5UqT5ylmMWNUqPnJ8dyn3g7JcLV5qeaP2htQCqBk+D0ggjHBvF8ZUaXGbS
	QzEw3v8THOMwvjBQy8bU5K/W6trWQxMut5Ay2HUVa4+/On5bP9teS4hrQGS3l2dUhwmkT3
	P8WR5+Un1BGr6CFkipV4lwdDb6IWQ1M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="M fiOEYh";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=itIohdwI;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of boris@bur.io designates 103.168.172.152 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755563788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4caYZdtkvA1feHd6+f88NqFxyHygxvgA0Mg2AX6ppA=;
	b=mAmcPJZLUDIJ/YbnNlGqOZKiXMgOmjQrmInVoR39uMrL+3JbcQWxSNbW5UrZ1LePe0RGjY
	IgqqLX01+U1h5djsS3ms6/e4Ve6tQeYv5Hcgk2kd9iFtrbWto9XbAhTR5sURQ918Vd887d
	EWmik8wu6kbkIjgENTzrpr1WBjCFggw=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D8B6B1400721;
	Mon, 18 Aug 2025 20:36:27 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 18 Aug 2025 20:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755563787; x=
	1755650187; bh=O4caYZdtkvA1feHd6+f88NqFxyHygxvgA0Mg2AX6ppA=; b=M
	fiOEYh7K0UFAcWaolcZG+Ywr4V0M7ZjmJlJRl2YwTA53RJbfchbriUlhbRFvik/u
	d/t7TPSkCHCJgkRtnr5MvZY0CL3tiMrP2fOGkC15YXLw+DzYbBzuu/B0KoRf5C1i
	XEbhZbHSK8ZZI63hjiwYlACDIqnefW9vHWdLcfWPkV+4L+XAQEmW8gL3UEXNjHrM
	CmVLlpUK/SgDg6h1myEv87ZTZFtSApjcl67Sq/kl/REHGWntF5Trbtu8B6fpsGoz
	NqYh98iZm/WLbNFfmkLQjTEKmYUSC1HGtBAcGsig5CuMl3fZuB/1u3qkZdQAf0wx
	p1MWoV++ehrmDzP/UnbXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755563787; x=1755650187; bh=O
	4caYZdtkvA1feHd6+f88NqFxyHygxvgA0Mg2AX6ppA=; b=itIohdwINivHPQs0b
	S4veB1ym/yBiCJT3Te7pYh1ookGnQHNrlh4wviZe0gOn9F/fpRhku+c8pUxFxNc2
	HA4qRY5/oeC7MyR8d0paISMdGdnfoBN7DvHGcYx8zg471bqZ0xQr21/eCCMw12Z2
	NxOgeOjAj6Ch/oL/mfpInk2VRLdJASKtv72UrPM1qHELYDC+ak9hzoxwpCUSvBW+
	v5U3RryC9R0c8o9IdsR9Hk34zFPh06JYsx2pWkuN6HSs6a5r1a9H677rkb4Q1TAA
	+1TG8N3MyJwOz6DgIKhc0530tQcOl4w1P5Ny/1vTpMmcTMzWSimg1RCb6qL2AfvF
	LnyOw==
X-ME-Sender: <xms:C8ejaC2CsjFhVr2Sqgw1N2dGLM89YH1i_AwILuBs1asgCyK2v6RBLw>
    <xme:C8ejaKlx_Ne-VtgRf5tq_g0O0o_dA1HoGe7mu7oUpn8e9q503POwmSC6MYEhaIlrq
    O3v4lhBKPyCl74TayA>
X-ME-Received: <xmr:C8ejaJ8MZUVMaWQcr0dSgNQWbwZLcXDg19JK3mqN0zBtg3TbQPqfkKqgb-BhVsvaJreUxQpgl72DT8ZzQ9UqeecTOUY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheegtdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepgeduteffveeileetueejheevveeugfdttddvgfeije
    fhjeetjeduffehkeelkeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeduvddpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomhdprhgtphhtthho
    pehshhgrkhgvvghlrdgsuhhttheslhhinhhugidruggvvhdprhgtphhtthhopeifqhhuse
    hsuhhsvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepmhhhohgtkhhosehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:C8ejaIJHiqOL4IWKQYHQmukvJfisvuJTVaVbp3T1e8sF71otkoOSKg>
    <xmx:C8ejaOi8YdgbG8OASKxjLd2ggk_hkrLmQL8EJADC-gHpeztN_MHwkw>
    <xmx:C8ejaE8AJsRWbxGFXWYgCnChUePr3ZOP1Muvf26m2D7J8fjpUhtS4A>
    <xmx:C8ejaDO7ttioRecgQEa63Qf-LEZsLBqVY7jEh3cvRbUvlBSLjEssKA>
    <xmx:C8ejaJxW-ji42xP2a4dcqp30Zi1ihoZfa7VZ8cNp2UVGlAT03eDbKQ89>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Aug 2025 20:36:27 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: akpm@linux-foundation.org
Cc: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com,
	shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v3 3/4] btrfs: set AS_UNCHARGED on the btree_inode
Date: Mon, 18 Aug 2025 17:36:55 -0700
Message-ID: <cbeb05a98ceac523bce55a0eb12e6d6ad4c98d12.1755562487.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755562487.git.boris@bur.io>
References: <cover.1755562487.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 77962180013
X-Stat-Signature: 6t46h3tt9zmiygywtzsganmp7bdp767d
X-HE-Tag: 1755563788-704076
X-HE-Meta: U2FsdGVkX1+JUz2dpacFPYrx1kpHc7xuOMUULO4RIsXm2HT1Woek88x1NHRU0Pls5o5XjXe+gukeBscJM9oGhzPnmhh6a27qwosJ/fKOvYX4J36T+GfL642HbTNeW7+ik7oWE347rEFsQ4+Z+6/ViqXEWWzW63xSAEkFxerSdODRxySX0Hn/c2PD/rMQemj+oAaZVDSQxyEgoc9UTEPq+dxwI9NpfuTiJq4uz5k1ZN6S69s2Nj7H33uEGRD3L2XKJgWnfO8Tkk9jV9Xt1IB7KvgwiHhpLXwYTDgAblD4erq5a3ItFxqm+9rKwxLhWnfbraEk7VNDbRZzTMxfvd0I4WwcdzCTvvEqX7ZPojMstUqgXZmP8mayte8Pw7aM8J71MW7d4xw5ayIx1ck/kNNAP/fMCg5cPiq9r0qkhQzjFe/cWf7Xeb4+WyVXh2BOBgQJUjpcTz2ap6/RCF/fANRwlu3CZiyAY7a7xdlTJFqN1+gklyT4OZa8L+h7CeaUNFFImjITkSbjz2xwYGZfvclNkaRhvpw6MNUnX/dAfZgzVVSps3JCbsyWEF/2eJItGmmCd+ICNy3nAKh806OzgS2mjh/CuR+7iV4ErHXAiNM8nmeXTdIZS2G3xA0cG2iRA/4MM40p8y3XMwdX0p/nJLXoCoQsVteteS9JqkyyhmibogxUKj0ewcSLozpU7lHNbeoQUewISoCupsyMa0+GwuBqzHcYagIOel4edFsqO04QEvmniF50U+avZPEvk3X23CDA0LLnBnX0h+CAGa2TA3I2/Q4lVvpauzyvNzadlIFrwBSuFQeHnYslhaA/0qqkAoCAJmHhLU2ryxmT8Nk9ZpUIQMU+mIZHgcf+GE0WGDKXf8MV0UygAQYxP4mG6J/zhANG5rW5yXW3Bm24x+CMH0voKVgeTmpfXqx2jSBfO10B2zUEgNIPvSciIFU77pfiJY/Hks/V5oB0vAqfyuZj0GE
 jmxBugdF
 xM2qiT5gnkEag/1cDWFnMiVtKOgGxborfHndE224njAEXSX/7iJB4hid+2SPRnEU+zkF6qpg2kF3BM6OXek9wQ1fXM0uunWQgrpm+feDYaeEQp+C6V6mfkyzdF7ImmKtGQ/dA8ISj9sWi4ODh4nGkptI7mm154DMc8ucnErWYGJzxGv0/ZHEL6tEXF91ZPx42IusM66eWifMJ7GpMbHUEQN34FH3H537bVSHXJ27ExAAbL2crKo98k8jxe0TuKmc+l5FNMSeRQTYqdEeMVMABOREfOtBzhFhr/Xk9SDfp2+NRcLvHLoh17DvXjwPwWQlSIxKDYbZOflDIdQbyIvGFa5ErtWSdEXVEpmHbQg34QMMN0YzzyKc41tp8mbeZc2CD/Oa027rhn5Aq1G3ro58hIw1DdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

extent_buffers are global and shared so their pages should not belong to
any particular cgroup (currently whichever cgroups happens to allocate
the extent_buffer).

Btrfs tree operations should not arbitrarily block on cgroup reclaim or
have the shared extent_buffer pages on a cgroup's reclaim lists.

Acked-by: David Sterba <dsterba@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 70fc4e7cc5a0..24ac4006dfe2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1930,6 +1930,7 @@ static int btrfs_init_btree_inode(struct super_block *sb)
 	BTRFS_I(inode)->root = btrfs_grab_root(fs_info->tree_root);
 	set_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags);
 	__insert_inode_hash(inode, hash);
+	set_bit(AS_UNCHARGED, &inode->i_mapping->flags);
 	fs_info->btree_inode = inode;
 
 	return 0;
-- 
2.50.1


