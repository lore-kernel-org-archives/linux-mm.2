Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767CFF31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C796B008C; Thu,  9 Apr 2026 12:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BDE76B0092; Thu,  9 Apr 2026 12:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3A06B0093; Thu,  9 Apr 2026 12:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 590456B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:08:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BB6A13BB6E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:08:43 +0000 (UTC)
X-FDA: 84639500526.03.F3D8EEC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2B0DC1C000C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:08:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=r59KVE9i;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750921; a=rsa-sha256;
	cv=none;
	b=eXGQ/B4G+5dG/ZZgc5EOiS8nQeZ8LDB/E4FUF7Jzp5ix1BMYCzrqEhi2cOg37lglbLmUQJ
	WabRMb8Mcx6vGeC7rdP7x6oCW3T+iJm9gVjoNZMGr75tqU1atu6SoQNu4Os/8KmMf9JrmS
	lTyyLfcHrhA+KkeR8DOiKnt7xGTf+9k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=r59KVE9i;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMID+rgsxew0RkSvMccqhsuu47v+LeaQSeiwdBrG0Ok=;
	b=nmYKZE5x21PRD7BDW0pG57u0f85Xb4TTY5tBOaB3NpT+bHG5EovDK4exEiOcod0ULfYUYc
	UPbLNyXH2Mm+l5tD2uI1RuFfRqigP16vR3ThZV7xTQO6x1F4JPzsQddy5C9YODBx+X9nNl
	9jRJWwwkMvKGwTYz22YEF99LZX9+Dqs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mMID+rgsxew0RkSvMccqhsuu47v+LeaQSeiwdBrG0Ok=; b=r59KVE9iRbfkYyt/uwNAp4hwIq
	gDKUAovMFJTRw07vQWwoYJazbbJyxyDXiQBouxmlEPXACR7CjHDC2ykHfr5yD2dWPQvU2yST+kNuw
	IDmZEFqKgL+k4UlgUrZsc6it3JpycnjJYh4MOup2Z97w736aFWt8yWKUEnetiKfa2OVM17VemusRo
	SaIPZvWXrQw37w2Ya2O5wwUa4EJNWWYwmgcAGSSyriMKWhzkjE0rizC3Nf1fNrOFY6Jx1dMljzFxu
	iSP4Dun+RWNHh5QlICAdg3XjmXUc/+QhhpwkvTcdkcstgumvHBz3Z7PYcPdrmomeL4ZpD9CRt4WJk
	gSjazsBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArvn-0000000AtTF-3Uka;
	Thu, 09 Apr 2026 16:08:35 +0000
Date: Thu, 9 Apr 2026 09:08:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v5 3/3] block: enable RWF_DONTCACHE for block devices
Message-ID: <adfPA0_U312XhCYF@infradead.org>
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
 <20260408-blk-dontcache-v5-3-0f080c20a96f@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408-blk-dontcache-v5-3-0f080c20a96f@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: rqjjuoad8ms65zjusuuzrg6gqssswbxs
X-Rspamd-Queue-Id: 2B0DC1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775750920-855881
X-HE-Meta: U2FsdGVkX1/OjEdptD2q6ySYC4HRLHvqyeiY6AMCXfktecxqttmWUpw+pt7ovNqSPH84kUIP5LA98c1v83Ce3Hw+kSYNd6WKFmt/4TcWTMLM/4ECF02Vx7JQ80k4/ZU2wi02BZlQGnToDhVb7wTJDNvO2c8/DPBUoJ+JKdghfJVEoHpZQwqpXUMBLBP2SvoPFW0fnXrmwGdveg8cQPDYnBDreIjdOioG2L9l6QL5UlHnqFr7onriXqAAy15FMk6EPDViR3Q3OCAVaTDbHQ4GR/P0MnoHaQtYZi8asdgrzckHvMEUA26hwidKjkcGusmLUATsdOUZhmD8twjHOFMug7Hoz+t4m6YvQuoPL5DAzOLzzhwMk6bQDjw2Zi3ZFuRDyYI3uavVuQCMY6WRXb3KjMgbpanLmdoz/gqvLmGa7aXvDYkP3BdKczck25rDSZwZkmBrXz5Jb2TsS4E9kX3th0zlzYUHF9NQ7MK/y9MuCx5TiER/8znKnqa3l/H7DQr/Ab4+TUhzMcCosL7NYN0xrZ4kB5mYB7kAyb4RBbvoI0OK7RECWjxoUq9HD55OlWDaK0hbBvrs9WCk8IdzvXabMd/MM4MisjiNIZaK0shSgCZ7RyKRgbaVXUkcijZ2m2CjIN5Q0xoIUuYFV1AOLtgs5+FBRtVHLXQylMSd0M/XP9HxY9t5CAhBhjzRaEbZq5DZXvsoFXeemD5tRfQN7zU1k13sgd6eQO8g8YwdPa7WcNYO25ovnDmXfmVk33APt7b5dlCPgXF3uTnzeWyGyzvfycG86H4KFR/YaR9WJQOHe3nyVqaPinHw/NrA3sNO0SWax4NapagPd6XhDC+wNiUaJ7XOvU4/ODcgxfaKTq7jxnCRBbtKOnJ7eSpZRf8PgRphSDgxIzG9LoLSMaE+ANpfPbqLegMlUhTZLmymBaw8NC1TtmNfQ7DZiydPtLj2q4SI+45qfPhzFQiUWYoeSUt
 aBcKsKC2
 Yyr27jS/uuaZorhDGWhHnmtcZJq5pIM4b5bCvC6vTTopOSjSVfvNwbnRDL5mf7aVkGJts9o7xMbVVvCM8eCKb92F5euWYwqXAIEJigxgewt5CDaC79K6uOwF3K9QjjOmDxa7vGuY3ADa2a+nt35FsDJgUgU9Vfoo6MpSaCus/YuyXuOn8t+AwawY/zZeeYnlHa14To7N9xEmjYE+3kctTdljWQmyDQZKT/mMbzvOXAs5lcy1rAC1DyYLgAE3VYbdaQTqOuyjy/7mvpzIJF1+HfKRrRpDlhIqA/50vTGvbYap8lXQdrcthtVXmbYVhq4LHBcqt5/uc2laZfbbijk2SCqPJEjDUyLktPEjLw0FUAd7jWiLjWSBKw4O5OvNMtrINCyDCMbL4KJj/WTMj2SIWhhkdMHh/Xv7SqqU7jS/Pmw5/XhHrK9VyeT/h2k3iynH8j3ZQpoFkLKjwPedgjZdutaSsK+x+aMzlJCHtC+dqir6W3utahas5v+VxhESeqdzFIUhRiqUzixMiKsWE9D28xmvK33eefVsqz9G+UTmSMCvTplE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the next round please split this into the buffer.c parts for
the infrastructure and the use in the block device file operations.


