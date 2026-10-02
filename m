Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA582CA5FE6
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 21:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBD96B0092; Fri,  2 Oct 2026 17:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACC86B0093; Fri,  2 Oct 2026 17:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3A66B0095; Fri,  2 Oct 2026 17:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F32B6B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:40:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EF631A084E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:40:50 +0000 (UTC)
X-FDA: 85279006260.06.56326FC
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1727180007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:40:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=mLqABnr1;
	spf=pass (imf24.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790977248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtjuBaVBtKpkdhX//57sGHQwbbwgWOKhzo+1Wz1Aci4=;
	b=YMYWz1CqO1+LtwaG+1Pd9E1fE+eecdZ0XBo7Ac/Lw5HhCS5MMi0zpDgdio0Xsoc22dvwp8
	MF20f+XzQpqSCMhURFbvW7hdz6tvCZS9jlSfDDglJ2Hiw2FMcJ7Fd6O6hvDTjzIjO3akLJ
	Q34NjWESXBd2lwJFEmxNjbDd+aIMVqs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=mLqABnr1;
	spf=pass (imf24.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790977248;
	b=IT9aA7+m6saWdVh/wezw9l5VepK3xV3LRTI/YPw0FTfpDO6HPN1O0kFRoVF/xf9K4wxQpO
	9Sj24QZClWha2lzs/1iuExMxq0dVC+51+ab6i9E08NawzW5ETy/NeEUNylGZhc/O6JyY2v
	16K4iwMcMySjGsh4iwtVCKOyPJ4iChs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790977246;
	bh=AtjuBaVBtKpkdhX//57sGHQwbbwgWOKhzo+1Wz1Aci4=;
	b=mLqABnr13OiWgyHlPw+Q6L1xwFRMf59LA4KL/GPNFu6E0UcmPMWvI/OD9Ld85nWikp59
	rTrAC22X2fDyipD8zSJo6HPpaBZqFSvXwBqMG6938x+svJhaDOShuJcKWNH2OqerkLNYUg
	87lZyXLvi8O/bd2LS2R0MRytxa9ci5zDHoRJ2TXIvG2Zdllt3gw8t+DF5nGg3MEEj7cCfA
	hWzQNHLkHGSX7YyoEvfwwAYP2+olMoDwBMZgJaMLdlztccLbhgzBhD8QoRg954Xl3+spZ/
	ersBJ8a1XT9nXlsCipX5xJmKj4Z1NP+oiEg2OtLJ6xb50U9o0ghG6nWSnTkTZoyw==
Received: by recvd-75d778fcc7-5kxrw with SMTP id recvd-75d778fcc7-5kxrw-1-6AC024DD-89
	2026-10-02 21:40:45.735661736 +0000 UTC m=+276011.229270050
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-64 (SG) with ESMTP
	id Dm-Ltn01QA6RCONnft8w1g
	Fri, 02 Oct 2026 21:40:45.667 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Fri, 02 Oct 2026 21:40:46 +0000 (UTC)
Subject: [PATCH v6 1/3] writeback: clear the old wb's dirty IO state after
 switching inodes
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wb-dying-cgwb-flush-v6-1-1991b4e2dcff@honeycomb.io>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1707; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=zbX4cnEABElDWqQNtrSVaBW0Ked0tvk4MWPkaGIt+6w=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqwCTbHKmybgMSFWqYOqVuQ0Q7s0V2yCJ8XziZ8
 O9DxyOHsXeJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCasAk2wAKCRClztTjl62v
 wgx8B/4u0V1aMjqcyxUZ2wpnLOD6jkCcwOUPNMiqsi2tdsqyI4sUvELleVgSO7stj7CtUBhmfyP
 y5BccMCdn3YXbVUth3FLOdlBADfDF9xMyedYUi7eGyHdx654JCb39LRXXgq00ZgMPGDcFXOFp8t
 JfqU4pvOMfIoA3GLvyPYeUf5MHSU4Im8ceRA9MrjSRBdxID/FnNy1Z5m/deP81YvfJL5F/Z8IWs
 TQ6DGTnqHpiU3JZUz4qsFg+AerhKP7Jl44yeh3vZ6XpbnT1YpGL9a32vT+a4F/F9cmmWfkEGr7T
 4Fk7vF5HVdFQ3JgduiBf+nT4+TCyTOWREbf2yCkJVo4HIokb
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeRuMe7SjpKgd?=
 =?us-ascii?Q?7aS6gNAUxeCWSVoTlVEi+vyXOAV69PW5X0TyP=2Fa?=
 =?us-ascii?Q?GVc9EGvWcV06Em37=2Fa2Gjb+6BNEPhCoIj7cc7DQ?=
 =?us-ascii?Q?s1=2FL0pSln3TjXj6NobUNbQL=2Ftjdp217HqJ5J=2FC+?=
 =?us-ascii?Q?RUUVlTUObdpHMaQHyAQMaU=3D?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B1727180007
X-Rspam-User: 
X-Stat-Signature: cdq1d1cie4gyqh5npcdxz1z1xmyje7ei
X-HE-Tag: 1790977247-178879
X-HE-Meta: U2FsdGVkX19Pm0zurlKcFc6cw/ETn49UiwDMQAQNfxO41zHzRw1iT7PI1AweNlBexLRj7QkuJ9h2UFfg6ZRjXwu7E94NfsCl3qYPW8gEQ0nDoQiRsZrSuDnFhTxQZkE724LpZXpZxXtDDVc7OPx6Jti5763N2KqgRa12IAaqTkI5/rB3/LoS0/eB4M/uX8vn5/pl7IKtC0eqpTkrY/Cu8luMvkprr57167hgkleCR4DD9A7ULDAJQWT2KLqFcc1A81Aab8FaspTV3pHevYPazg5r+s0jUyzNxzKDym07mn88SnKJX/xWhugv2i1tWF2dVkT+xUSTU+7xPG3bu8xUgruEmQymAWhnOmmKGakaTpZ8q+yItcEEy75ldiDCa6Ip5gXyvJ30ee85xfHwzycDHUHxeHJfxdzfMzZK7mQ6G/hgde581zShlyEKjKDhoyyAhYr+2aw0ABIZAtHRlkZXQ4nW/rk5pVUbvop41liSmEgE0wH5+rLx3ln0lDDhZAm6cQmx9rkrlhu2600u718EyyxluYUy8YkJ2gqg551WuM1mD4sEJ9WTWhr2hUm0N6uqysBTOR+7QDxx7kpowTCd5VcYajFFBOTnE8moaTJJr3O1DfBQwXvsvu40UyY9RO4ntDh0/oWoQwL/MHINkU2IZZ3tctRXK8HCj5qKXgRjG027TZkCkhWmQz9dpCyUCobkmuS9X7gQo0rEzHfTLEBF9JTH9MDXrf8H/Ie1Gk7teWIb2HFVu4YCbQHs7OVBxd4VrKuOTaat4XhRJcLtUhgiwkPwYGP+UiWPasZXFP5uKaDDTq3B65P54PWzIkKwCylw/vz8aLagcQVZmagTJq4Pky76q2a0bRbtzm3kMG4l1cCQQxwn7Oe7kzu37cy/ERPfGgn7f3xWMckymNKq4gWhPUQMX+AVY7uHlyauyjf4WtOCVamqy7dhH7WeegjAKU+/kZsX1gLG9Y/XQilQYR0
 kcrzVCPd
 aprG4Wh3pssnFnAbyVcvSVwmfccWs6dbtEL7Tq5Ga7sfoHNCujceKMNRrtDgRMZKoukOrpEeDFat0qQjQK2AJSNBV1EruX1M7VxhvRiaT3m0RrDBG76xY6xMogwRtKKK/gSDTgPtXg8Nh6hAw9UCplHHv6dV9j9Yb6enmf3qQTa0nd4eUit2v6y5l1lZpQZKj4EScw7G9dY74NpdRo6qtppUZGGMLOTR1pRiDD/96LP8kbZhOei3gxumuMjPTDsugHRjWz/x7FhVyVlNCXw1Rci/hscwrH5n9ucwVFEvWxCtLdrdAvV5lXk9XySMHsLA5Um31Dj5Q+bewEgEBtIQ415PiB8pGLDPywbxJ2ABdZ5W57URKa2OC1CchWnYvvGRK1Usrqvt2Br23qcy7LMJe7BJXJ5xAXPOunK3lIuoOIEP9PgJOAh9bYoNCgoNGyb5MVAGcvmjpZxHeJ7+NXx0lKMYJ2NNsWwtLzW/GDNlCh0r8eIfsVztwUqmZuJvdesnBt5x51A4bPhPla06hSZeQ9bbOWsl9Ghvr3b5m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switching a dirty inode to another wb can leave WB_has_dirty_io set on
the old one. inode_do_switch_wbs() moves the inode onto new_wb->b_dirty
through inode_io_list_move_locked(), which only updates new_wb, and
nothing calls wb_io_lists_depopulated() on old_wb. A live wb clears the
bit on its next dirty to clean transition, but a wb that gets no more
inodes, such as a dying one, is freed with its avg_write_bandwidth still
in bdi->tot_write_bandwidth, which wb_split_bdi_pages() and
wb_min_max_ratio() divide by.

Call wb_io_lists_depopulated(old_wb) after the switch loop in
process_inode_switch_wbs(), while old_wb->list_lock is still held.

Test: after the last patch in this series switched a replaced wb's dirty
inodes away, BdiWriteBandwidth stayed at 411700 and 407820 kBps with no
writers and b_dirty, b_io and b_more_io all empty; with this patch it
read 0, in 3 of 3 runs.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d26b2cf05283..050d507aa554 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -566,6 +566,12 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	/*
+	 * inode_do_switch_wbs() only updates @new_wb's dirty IO state.  Clear
+	 * @old_wb's if its IO lists are now empty.
+	 */
+	wb_io_lists_depopulated(old_wb);
+
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 

-- 
2.53.0


