Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE08A606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FsLNePpJ
Received: by kanga.kvack.org (Postfix)
	id EFFCD6B05BC; Sat, 14 Nov 2026 12:34:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB07B6B05BD; Sat, 14 Nov 2026 12:34:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7106B05BE; Sat, 14 Nov 2026 12:34:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C039C6B05BC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:34:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BB83A03F6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:34:02 +0000 (UTC)
X-FDA: 85434422724.07.58EFD86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9F83320006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:34:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FsLNePpJ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794677640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFpXgHITgTKpJjTXjtCWWLVB9Sr0Cws6b+lQmt5jk1U=;
	b=T3d7B8i//94FzYhvCw7jf656TnHowVfAIEjPRxTvT89+WQiSkfgmHkFap88zf/n3BX7600
	CQrlgU/+1WwOjr49EOctdDsdLya1ugD22vMhRALNUNkEYuw/2lLisKb5rM3NSLfjRW8Ykl
	3IQJGuv7eVhvXG/h3B7knd86z9bW/H8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794677640;
	b=DDaMnrheUOahXqd29sAjwcsZFuWLOK1RFJiQi2X7MCIa8bAic0gzcja1YzABMQtNuzohUS
	S/kJjlgmfQn2qr8ud9M1VkyAUnFHXWH6qmLi10NyjHcXJHPn4FbRy14IIo1f+/1WAYo9oD
	LhMURi9uF4EY9IzKiN6Wf6qt1OT+Zzc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FsLNePpJ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3449760A86;
	Sat, 14 Nov 2026 17:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F041F000C4;
	Sat, 14 Nov 2026 17:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794677639;
	bh=KFpXgHITgTKpJjTXjtCWWLVB9Sr0Cws6b+lQmt5jk1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FsLNePpJ67WtMpcBtQy5xfKYA8q8BcgKSYhg/XRLaH2t1/FF8hLR7UoKdJraBOxcE
	 mUcuBh8eE6I3Gc2ugyua9WSmZ0AA6V1bC+vYLhS4By7aboCtudxrYBWFOWjmiIXlm9
	 3yXMG6/bWUV1Dl2RBYP30+uk09PQc8G+doiN/1A3LmSQIzvB6IPQ6E81WOae4ZgXep
	 Ex96VsoDe7GoeMgLCOzG4JLml+P/7byQ/edBRG3T2El3sOLbwfwWxhqn02s3DiYmGu
	 KHVRl7BwzAImFEfP6iUMtKE62oFQTpdqd/amfbZSaHcD/7ElZWwQ3jrBMZkZw9loOk
	 LgSv62x2CLRfw==
Date: Sat, 14 Nov 2026 17:33:54 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/util: fix off-by-one when checking folio index in
 snapshot_page()
Message-ID: <avibe0HG4ssUUuBX@gremlin>
References: <20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn>
X-Stat-Signature: ycaswpnn4uah97tibhnkhm9i74xr3718
X-Rspamd-Queue-Id: 9F83320006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794677640-702166
X-HE-Meta: U2FsdGVkX1/ZM1k9BQFcX24W2yRokJMx/oc/+U5lg9WBOgL+3mYpsFkXB0kqtNKgw2sfCTLuZHZeGzWiFRbPJOCxAIoeNxVKlKDzprCjEa3TFYfy5VgNIODVvS3UhdlibxHf7Uzf/3KImvVa8hQN0OkFROmQ+IY+L0DYQkbeCwny22cg59J+EAZxVaRWA3C/MuAjZ+XnMBDJ4DEa5E2ZB62OwZRYDbGHTVRHBf5C7nyVropFHvC39wP5mOst8n1TpMitma4VqBUGNd24YJK1NlVyPKZudiyS8OXhqxgqs6eSLBWXB1a38aasiEpI8EYn5+beXPJAAbBqeu4bVwYi0/7s0Ci8ASznpvTWPw40GGTVDgnmIU8pXsAVer8thlokxczkfVJ5qoWimixxYz4g82GdwFv32qv0dETQmJq9zA9w/pxUbGGud5O5YlQpNNvDRrmIeFWYMu/fIINxRBYGLj16GcpyFS5CpfelmeQ+1s9nywO3ME9y9rntz+fivexiKb+NYkTTAijCm3KaxCoBdyacaxg2AQMZw+F3X9nipu1btLIoYu2ap2R+D8XHsUv3KGgkZ/gBdNwSB0tbhruvOb5PqAUjRV9T6IOEkzeje+1Ppo11FAbaRdcwaPYt9s3fEp9anf4Ap5LDgHeiP2ay/fszdPAEnLmDt02JpHWD4AHn4mJmMlJzW7fIPvU6L3fcZFMTLIuijzWY24tUG7J99eAsjgf3rhqkxtewwKEVnWu6dvWdjygNRlMSq1Lk4WI2Rpacf2iGFDtiNBh7Hqb5AeEG7vW/EJxoQyrPr8MTPxXYjnDsNIbxA1AWqf9azAGygkCCSmVI02Z69rlIONKMNd2Nh0ty8zn3zCv/dr8Cic5/CRb4NTfcDzKOJ4XU3koBhSe8xPrrm0AGZp7P2UHoFstw3mWj42YNlGKLjwU5EkFoSGdqC9jjO6GJspXQT63vdoYcktImsjcQsynmQnZ
 N/z5tBID
 C7L6XSrYdZf6uVWMdJZQ1yyTk5c+EEmM3K1NsQbKVKdO5K4M6sQBkfkfMuZppT//UfCVa6P/D1ZKXFpUeP2/CtOTObuIfrz6A7BOy+Lk6tynSdu7Ghl8jc/N2aGUKfhiMmlvFplnLvpXAg/SDQOdnbOocqh8U0Q2Kj4V//MAL/T28hRlsarKrRlljvMw9wF9O7e0JgFMDsy0q3pNXGaz391mkqVwSmlST+B+6kmlvWLbJTpbG8OFM+IwtCjf7p0DfgsEqnDzhmd1IVwK5PS4jDALLh+zjfqCeGqXGGCyKf54bfrHa+f3ZiYTiaZB2dWXZL9EfGmRwnPzKW7aWHMQaZWqAEBf3eQ78jvtO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:46:57AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/util: fix off-by-one when checking folio index in snapshot_page()
>
> snapshot_page() computes the page index before copying the folio state.
> If the folio changes between those reads, the index can equal the copied
> folio's page count. Valid indices are strictly less than that count,
> but the current check accepts equality and marks the snapshot faithful.
>
> Use >= so that this inconsistent snapshot is retried, or falls back to
> the unfaithful single-page representation. This also avoids reporting an
> out-of-range folio index without the corresponding dump_page() warning.
>
> Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

NAK.

this is generated by some AI slopper's script, spamming the kernel. The
patches I looked at were wrong/broken, so no to anything from this person.

They've sent 300 mails in under four weeks spanniing: ata, scsi, target,
ufs, nvme/nvmet, ubifs, ublk, zloop, dm, md, mmc, virtio-blk, mfd, gpio,
pwm, spi, PCI, ASoC, ACPI, net, vfs mount, block partitions, and now mm.

and 17 series across 7 subsystems over the past 23 hours.

We need a way to ban emails from people like this...

--
Cheers, Lorenzo

