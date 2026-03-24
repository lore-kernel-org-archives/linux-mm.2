Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C9FF532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1F16B0088; Tue, 24 Mar 2026 01:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9A46B008C; Tue, 24 Mar 2026 01:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8106B0093; Tue, 24 Mar 2026 01:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2E66B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:42:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B44216159F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:42:26 +0000 (UTC)
X-FDA: 84579861492.17.AD17A6D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 458954000C;
	Tue, 24 Mar 2026 05:42:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ShZJIyBs;
	spf=none (imf07.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774330944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnGFQgv2BByGLzw1hq9qZga1CuZS+vQ8g5BMMQp3Me4=;
	b=7jzJJMopKwTnOhOwMvR8E3DK0sqxiDFyCHAFRr0fNY3WqYc/YQTfuoQh2yJYGymws+yVN9
	CEGMpecmNTGoWCe9l8b7zd6ufMnoiMlMxhtcxPxgURaOWErvS6Kb43HSJqULrUh1ICrJTr
	4mAgWdCA1C7bS2o7n3bND7b4YnnfKSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774330944; a=rsa-sha256;
	cv=none;
	b=1wCaitbxE+heR/AKIhsrP/bt7g0u1QfQvCBXLcjrR+FHGxGL2nyl60ViJH6AeyneLardj4
	dO+ujo7zLORKgm5X52ujwl536hL9zlrRgVwhddrsEUwhJ+0iu9SC6CfiiA9LlNVMVLDzwL
	99KUyTk4zcrK5JQPExeP64kyzaqfWTU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ShZJIyBs;
	spf=none (imf07.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gnGFQgv2BByGLzw1hq9qZga1CuZS+vQ8g5BMMQp3Me4=; b=ShZJIyBsPXklu8G8Q2+rirXnpz
	m9KHOWtXQviysvw1bU77BDdHs88FzgEmFKq6rJQKNyE6K07zB1zFlmXDr9uoNQqe1j9z3qewfntOe
	SiNtFmOmubhI/X5uf5wMClzwKnDdAVPYQfeJFAL8i681WEXEJ6Ge/kbNm/sIi8BhXVfs0IlqcMZgl
	iWkD6S2J9+7CRMttEN8ODM2cw4HwZ6qd9bMawbsWUC7AOBJ0hjAScvzE3LKhED1QRAEPqoh+HLmra
	19I4mUAVR7gsRhaa/0XPtpgK+TmJNyqPD9xkyiZdskMH8HLvcfUEyiiMCuLOVSjjrHHQW4tmPtXF8
	eiug5RSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uWw-00000000bSG-1SyC;
	Tue, 24 Mar 2026 05:42:18 +0000
Date: Mon, 23 Mar 2026 22:42:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 20/41] fs: Ignore inode metadata buffers in
 inode_lru_isolate()
Message-ID: <acIkOmat4Y_M2SUC@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-61-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-61-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 458954000C
X-Stat-Signature: xd9t8e8hdyzh95twmg3i9dhpa9ckrjfn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774330944-721132
X-HE-Meta: U2FsdGVkX190TkbyBmIXrMBMq9iky9hyQ2sPz9wFGFx7XMJwo7Bt4XeQ4r+vxm6P4El2cyCXFYIfvuvgLLlfaHLDrZsSuK8yidO7hsNNWkuHI3yOXvZsCY2Jq+CoQGpj91VUkOP19ffQVbWn5vZWRremt/nYkF62nobFhq2mqHdkZMnFW7VCnl8oTfJImG0/X76gk73maCPQWS8ZKwvBItZQT/CW5ms6/sVV4cIGJwZAbgtg7WQ+qiCv1D5fKg2w4par2pWgMHW9GesxtUQzriNwR4VUlaZOpCfl8e42tQ7bXD2K5ZqNoHTkgvUGrZHDxdKd7hHFhwFbP/5qaGhkTg6iEl70NWSe/7PniZF8iLMH36kbCQ5rBJafEqVfKM8XRP5tdcIKAKzZJ0hlFbI4gPk62xy99LB9QK3Ow5Hv4a8/coHuzjMyMdNGhgR7tyhrAZjDQvAtdrivdpwh8+cdddbnqnxF8ttFyjYSb1jcgYSuIsJVyb6nQCTYXeA28dl641NAoqal+Jy2ulN5y4NgL2ELToM50/7ohru0iF/84QYOmzanj+hLLHXj+oCE2sf8CoD6uaw+OhvQuoNUh6J9k55qojdKZFVt62/8U784kSevRdjxxjTyp7bPPMRCaRpau10NNH9qy7hoq0PSw9GGDfaJluJw/9TC3IyrWUS6M7bAvVrNZaOjpMp27+UbuH4EyJgfdjK/Sfsx/gwPqMAseeDZwyBxNMoZtuqfqW6f0oIYx2cZBwqFfp57Ckkp1hh7IpSWUTmxBS9TNdkIWWU09/Rjq24Wn+H2aMgxZjR7gJAP5bM373mj6quGyAXSV9T1J48EB/uEJyKRMpOElDCShYFGPU0RNur7/zAhG/WIL0ifJGLTIrqzoZj6qB+rAAbyeACndACh//kdvnh0Ne3Jlylg/e1gmCvxJlywmdobeKsYk+o+FBvs8c0gAsQL4U8GwHI83lMnLapGDkI5vjT
 BDCLnPge
 p1NHHw9bMTzyQZNimlBLWrnbhCmS71yCwHPdoZb7FjmlfZLSgn8sXX9pzLGKbR3vVy2sHro3w8alJV37qbSEsqZau+uJQhPRORcXfCktG8ZrXXk8ct447FWiIKX2tkSrkIMAp6fD7pg1Robxx5Pz7VO1TC+v1nI/PSee/WZNREoSisDdLSxGcWs+ITvnue02P0zXPuiKEczJEydUelyOYPY458l4dZi3UawYvncdvg4QbuBDOLp1Dm4N3sPcycvQ7joMQyFhN61FZZ71SiOfr2Hv1oOFD0ADh14JZ1f1xLbY+0hPq+RKDgWYxTE38Ku7mYc4x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 02:41:15PM +0100, Jan Kara wrote:
> There are only a few filesystems that use generic tracking of inode
> metadata buffer heads. As such it is mostly pointless to verify such
> attached buffer heads during inode reclaim. Drop the handling from
> inode_lru_isolate().

But the code isn't just verifying (which to me implies debug code),
but doing actual work to remove the buffers.  This does look like a
behavior change to me, buf it is not due to previous patches or
because it was dead code, it would help greatly to explain that here.


