Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFC1C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 03:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC076B008C; Mon, 28 Sep 2026 23:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683B46B0092; Mon, 28 Sep 2026 23:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B256B0093; Mon, 28 Sep 2026 23:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34AF26B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:42:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FC91A6954
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:42:25 +0000 (UTC)
X-FDA: 85265402250.21.D89E48C
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf02.hostedemail.com (Postfix) with ESMTP id 799DB80009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:42:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=ezrNfBFy;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=m1pxEK64;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.137 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790653343;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J+5l9qBwl1WsRT1XtTAjxybHRH86RKo2RdAumZXCUic=;
	b=iyVkRcZoeAmc0CMLjLeOoW4a2so+ueO9VCYUAOBI19Gw4zP9OxfmZhbSatUWhYFAL9Pkld
	urfNDV7mER9i6RiAse7BoYcLtig+EHXkwd34R48w98jFfDioyFZROQlQJPQWzcZs/n38FM
	/tiUnRH1XfTxNKCsMUpSWLnAa3eqFpo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=ezrNfBFy;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=m1pxEK64;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.137 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790653343;
	b=snmxqQ+n2S6jE7lCZpVbC+xTJ5kkcfVpjv4oWFofXF8SwWSwYB6/Hl+dipriI6imO8xeWx
	Fe7K9+6QoIzH4JXpz3Mq20n1s7Jhrg5f68aI3zJS86OHiK6rgrDkONQOGMXDQiTHNt+wN1
	OJEfFRvAx0LI5dn/Htz72wnmo+yLUuI=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id EFDCB1301921;
	Mon, 28 Sep 2026 23:42:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 23:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm1; t=1790653341; x=1790660541; bh=J+5l9qBwl1
	WsRT1XtTAjxybHRH86RKo2RdAumZXCUic=; b=ezrNfBFyCCbOBOQcOfLx8TAUnY
	8SgRBoaEspMTu6k11+fYYjuEnc3SePghudHE1Dym9tFUvy5UdnR6Ku1ax+jVwUNk
	mVCTP1FF9IyZ6hRvfNCp6sUNtNrtZZkkGBgh9WyZYju6hbyJQgqaTXvmXlknQb3N
	RkcAIWz/GZnhwYc22H/f5F1NAijCRiBbGJp1y9s5JrEv1QKv6gvQ9WyuZZS1GlMT
	dHQ0otbWzyZJY0KO4jZta/EWTfL1ecG1/7b/lT1GZsQXKKUWObXbF8DV7be4ynW7
	hI00msB0tj+bAz8SjQa0Rsfwm4uLkf/mA1RhrYHFG5QbJ+sZzWj5sbcGCFxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790653341; x=1790660541; bh=J+5l9qBwl1WsRT1XtTAjxybHRH86
	RKo2RdAumZXCUic=; b=m1pxEK64gcDWc4E2kWsLqlfPzYLSD2ut6wsH706XVv1L
	fE211x87dQOmSZpUSu7g+gTHfsKRktK0HJP8MLYjASkEWZsTOIFkO2vnhygFeo/U
	HSFK3JtI6z3nsNti3fFP2txOe5BdAPzf9Yuc9sFdRN0Sgm9RzSHUCROB0k6WAOoA
	d0Is6fPQCoGDQ9SJRRAvDV5QgxuDJL03wb2vGFovMa7thOHOdW3k/E2nN3bd1PT9
	RG1jYCb9wqtuBdNqsMpKOFjtrY0/qD9CrrvCYDb+ME33gLZfGphVJbfpRSEFjdLm
	9Nf6GFQ9vOhMx26WrlOi3L30Jx9M8yQ3quE1aedPHQ==
X-ME-Sender: <xms:nDO7am0N1cltCdtQ9djUqBYsF9ZHmLY-xqP78oi_T1etXlChobih6A>
    <xme:nDO7asDDQ1CFjWJZN0KCCwdr6Vi6TibSGR7XCbeiY7YUsCoUk9vd6BPOmKnYfNysZ
    HWIdFjyIqMLOW-wfcH2nxhqtZj4FYBS9DZUy9LyvyVy2LViWos>
X-ME-Received: <xmr:nDO7anEtgWDuV-AopVIK7HhKtm16SQz3BhCda0qPbxxg85PcmTiwquc5aQYTCFVISy1U6--6jI3CcTQQKuOjnp9mW_Xh898>
X-ME-Proxy-Cause: dmFkZTGomu/KFUxrpCS2PBVtm+v19yviLpAfhlazZQ97X/zXySAcrpPfoYtOfYsfxCq7zY
    lGW7Lj0q0zn2oKEKu/P6u+AyN7TjCj3Oll0HkXf2BAP4GqX3CeIc1llVgOoBz3bN3WZH2M
    Q6tIcdcujmSjhTqphrrgME7zNVS3GK+PKx2Xr4EBWNcuJQ+AoVvLj/xprJkbTAIAwZhntS
    tMImrep6J3GRsD6kiFNU66dFdqiHn0qul5cSZnmWjQGzoHx5F2vUqryNhuQzKkMpwPI2gY
    BXyLLWJ3oAYxdycb0nryq+7vTjl6LxyJ+qGtpSTh7tJ4j1fgk4d8OBfq6PhvWje+2fN6ra
    G6IZUHCvNfteSCcxFURhEza6qCpIMxK+lwEL4xTmqUnWjwUjIGroWGapPVvCNkORRLt6Q4
    riKYch+nP6mAsL6Gt3yv/XSM7P7NlI4FsjjUi+5g7NjdUB8duxxE25wDK9tJKvmWw98/ZD
    75f7Sx7ZVvev0Mc6Naf9LwB9zX4jvPr5h0mo6mWnC6eLYuuAnmDI9fNdo92SVHGpRTh6GG
    vIcRgm+DfpFRD206QgvoS+5qiBvwihDwM65WiUcD3ykb22Hv5qyisPQ1LskoJWWzUdzTng
    5H1x2Fm/ZkOs1AZw0HR97QLko8vvi3OEOH/s95gMfYjRJuN14l24nKtrxKHg
X-ME-Proxy: <xmx:nDO7amqD-aQXz8A1eLGocUH-lGGAU2_LbI5b_Xbll1PPyOVmY_ciew>
    <xmx:nDO7an2N2Zh8-InhDjWE_eDbbUgapGVIuYvvhyfZmGVlGFKuDyl2Pw>
    <xmx:nDO7aiCiKNiJ4-p_oIY8R3W358JrqbYX32qapwUm7QlKFM1aeX_7sw>
    <xmx:nDO7aq_kBl6N-CbicD0rhINBhWN5NqsCKuDr0HuAffVbl1XfHr3kHA>
    <xmx:nTO7ar68mhMRu4Zo-zsbyfbxJFxB-FbB4xCNncCW73mXsJrvm687DM-A>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:42:13 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org,
	codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH 0/7] multiple-filesystems: prepare for changes to VFS locking
Date: Tue, 29 Sep 2026 13:36:00 +1000
Message-ID: <20260929034158.1455429-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 799DB80009
X-Rspam-User: 
X-Stat-Signature: 5jadgaw7jsyhi7x4i5qjn7rscob8ijzr
X-HE-Tag: 1790653343-911923
X-HE-Meta: U2FsdGVkX1/3VtyixIVFz/46Nl4++mh02o5GmzZrLWLm8wdzbaqq7vsgpBjqtI/H04AUS/jAMWLo3itPNCGKTY8KCEeepBdHW7mf5LGd/tuITREJfZiC8kLEnfBTiSGhNb+sv3dpbrGS10ISDfllMuqibn3ALPGrmDqcUg4qpn9eMj7V+RU+vVejMFLrIxo07QbfS2YpECC5pxCdGn+TaQMThexmz9RIa/O1RTuGYR1lN3NMhefbUJBhJ3hm5wjCUewFF32Ff1iHaxRa2YRXcyGNrhK3z1iQZH6VNjDpUYvZlaJnEOGYiej9vgLOEQ/mXwBQrKN88BP0Fj/nP/RnDmX4MNepyFyWu9gAUMTY6Nf/YAQXmAtU+QTIuOcnbYmb5+ZTj8TsRICn6eTOBgN3Mn78UcbFJLocNRcSxwc87v+WWEyw4UdXN+sFMv0HCurtSm2NaHg0wkUqmvNOb9gxIgDzfmek1TUbQIHWG7GMBRaYqItDg1ufiqd86lJ3KijP237ebOpO6yOgwVeBxH/PL7/KY/s/ALgvNVFeQ2ZzONH8SIZBgBiRCsBLWUAbRUNoJUlZ7nUlXrIzfRo3QEaZOZEGwmHzRRIUDqlZ9ihiajnpl/Xn6r8nsYN4wlLkXgcDx7tvRR37luTew/qObvOEDNJ/YUd7A8WY+1uvd5r9rZ1QndAsu++N4o/Wfq9W2XeePd/7j9KzI1Bw0KIuiHAu9Hu8ui3ZV5KZFK7G4fmQ7KCZS+5hs2ZLqOndErt0j5NOHgU77deDNdmZgz8huLGJQvE51uvjLs3lHLBoE8d35WjzcnRqVSL19zQmnESWrH8gfQ0KWYk9tWYCbn85M+WRbm3Oqr9DjwWVjmKKOCu9GVPo1CTNxSbtTYoOBQ17dftm1dc/hBK8rdJCEmOBxU6B4zDb+LOo7U696CmQGFa1jYIQNZ5Dmvn77QcExxtyQfDetTEyTYGkFttaAOoapoM
 Eku29YTg
 q4JPMOG0PR/3ehgs5icZzt7S4luqmSqm7+9h30Io/rdelcldgHxoAW903voA89ihdCMx1HWSJp+mZqnACvdf1H0qW/C0Q00+0ieXM/0MjaHqt3y6MESibAJNqYRAoQDmtZFkEp8yqFs6VICQeEZbdrq5RfGDsX43WB1jb0K9lDxhk/iZxBdLy1y5oj2iuzVo4DXfHxc9A/185Cm4ERTl7opXI7jgV4wxXr95aIrtR0SXoMO2ZH7hWRT1jhGL/UUzfpJgpyi3NNw7x2w7Yc2ayxjqdsFQZF9LzxShx8fRDowU0n4JTyeenUqYg5IQOCovs7U7C7NaFRMpgnZ5tgOQ5kUAFtsEuQ0nsVzJ9dOgBK7hkbgcqeXG013ZFRoCQLbKwux+hsbIhcfGKS5IewjGRZr1nhh0kOj78sLT/Fk/hpXIJAxPiiIs2MMk7D13f1FXZnXxvJyM1rzhGUdpUUYhiM5u/6VX1Wtpj6caBG6zQqKlLUBBH8Gy2KpUwOVLk6FyCniJARqiCsIhu0X7PgC+6zx2V1YI1KaAc7v9KIMIecZCkt0arDV+V2R1rtEqEnKw1p76kGoqth6JXxfXmo4FzG852VeI2VNoHNeYi5r2oHmCDeMQKPJWOdbAIP03DP66+VWBia4x7cfEsvBed5gB5jKH7ijZi+5E1O78D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I am working on changes to directory locking.  The medium term goal is
to lift d_alloc_parallel() locking above i_rwsem, so d_alloc_paralle()
can be run unlocked, and consequently cannot be called when ->i_rwsem is
held.

This patch set makes small changes to a number of filesystems which each
require just one patch.  Patch series for nfs, afs, cifs, fuse, cephfs
have been posted separately

The maint requirements are:
 1/ that d_alloc_parallel() not be called while i_rwsem is held.
    Places which currently do this can be changed to use d_alloc_trylock(),
    or d_duplicate(), or change to drop and retake the parent lock.


 2/ a dentry must not be d_drop()ed while an operation is ongoing, as an
    unlocked d_alloc_parallel() would then be able to create a new
    dentry with the same name.  d_splice_alias() can now work with a
    hash dentry, so often the d_drop() can simply be dropped.  Other
    tims it can be moved to after the operation has completed.

Though not strictly a requirement, the recent change to d_splice_alias()
means that there is nothing that d_add() which d_splice_alias() can do,
so it makes sense to deprecate d_add().  So d_add() calls have been changed
to d_splice_alias() in a few places.


The patches depend on patches recently added to the vfs tree.  I would
prefer these land in that tree too with an Acked-by or similar from
relevant maintainers.

Thanks,
NeilBrown


 [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across d_alloc_parallel()
 [PATCH 2/7] shmem: use d_duplicate()
 [PATCH 3/7] coda: don't d_drop() early.
 [PATCH 4/7] configfs: remove d_add() calls before
 [PATCH 5/7] hostfs: don't d_drop() before d_splice_alias() in
 [PATCH 6/7] procfs: drop parent lock for d_alloc_parallel() in
 [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().

