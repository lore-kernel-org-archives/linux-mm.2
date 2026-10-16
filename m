Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2233CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0C26B00A3; Fri, 16 Oct 2026 10:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A936B00A4; Fri, 16 Oct 2026 10:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38D56B00A5; Fri, 16 Oct 2026 10:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 890916B00A3
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:40:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BF341C37B4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:40:18 +0000 (UTC)
X-FDA: 85328749716.16.DAC9190
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED8CFC0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:40:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q 9FZH+y";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=myyfzQVq;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWJBtz7FZxAJXDEKnJv7+8CcY24QkoJWm0ZykJIucZs=;
	b=IVPSdwobSG0fZfIulZVf6hFGyBGNmIpgalmrHB23mWj2eNO+STmI20JG4wz+AleUWAO94H
	psDEKuuHs7YGLcWguqorEWHJaP/Ijl29DcFiBBmTCNqstv+3QjJbLo0ZhC5QRYdsBzpPSl
	a1wPohlQm7ioV9C0J1QFjw8VnlEkAcw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q 9FZH+y";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=myyfzQVq;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161616;
	b=DO2J7IYJu+5lwHMKxAsmmIxiZR0B2eij1dpffgFt17btR8yF1WKJH2/DXTNknMVJqEtpMu
	2j3KRsAJpFpYnnmAoVyv80DTxlU553EyKh1e8QiPdH++Zqy88KDuK8JSFuoYq81qC4Gyy/
	QkTBerE0pyEOBbyTJGAvCGgaU5N+YlQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 754B5EC01DE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:40:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 16 Oct 2026 10:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792161615; x=
	1792248015; bh=ZWJBtz7FZxAJXDEKnJv7+8CcY24QkoJWm0ZykJIucZs=; b=Q
	9FZH+yD7MuFwdoFP0q7bS2B5y1K7jmGy9QSkXc6YvgLux99zG/SqiVFf74x/R21N
	RTQfgB38znZWhmzPfmLAQyXT6FqAE6Yo+ZLstHOJCmj1OnJwshAvPrE4I13Jt4TL
	LR7kQohxMP2SpszDO03ZS0fBQy+Oo2tbdHJcIZk9K/yikS7mdBLd7EWgbdt7nixw
	KToj6mExZ4qllEJ5+FC0WaldDgn0l36kWK3kvWARd8OvP48wlvwFn5jjo/Kwp6+6
	0eMJ/BbWE0tE5W2hJOYKBx8OwpCYdDTxBxPm+ofxXTwczMgt3SmVB93zhjjoknYO
	CYjFO2IFIr+fmScTPVq7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792161615; x=1792248015; bh=ZWJBtz7FZxAJXDEKnJv7+8CcY24QkoJWm0Z
	ykJIucZs=; b=myyfzQVqzEtnh1e6ODhMMaNcTy9+9K5S3b+q6//7ozZcF52VlMI
	k+WdXQMlc67KLDYinFT/VeQ9BVqNebKnd7L4/+1mOkSbJKibOG8etk8zWkcFEBIq
	xlFtgXsAFEhba0IsnS/Yi3hn5Dy46q/0Ag3uxeFx5A5JUyUWQNxSpmbSw9h2hTKw
	CJiNSlbsHsPCWiZklg7SdIqcRDa4fAJ/NDjZWjG2AoNPWo1Pi0FaQb8MELqOqbAT
	Kl+hY5WObMVPiLEyRbmI0/uXwwIGSpyiyj56ijrHIIjRcUx/BsbH2BczCZarDULI
	XzRkc9dxmMrZ1vaWALYNvPHJOeYDgM8atDg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792161615; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:Vx7O9CnCLgxFziYF0MKcT+IdCB5zDqL0djqGQ6uOtgPuAI7
	HxS9ZhL7UunTNSGFzi8glMDlgBaavwZ0AqyDX26g1ajS+dKIiSPQauqxXYwQh7o4
	T6VCBzjh7hdIutcpf2gT4asol1ZFaJXyyslgx5oBivfNuvLDLN++ue2NfVNvEwSp
	4vYZQxOqmkEWQNWLTqSSeYZ8xxWtPhk5Z/lp3WuG75RsrA7/IdOD+2l3FFyX6W+o
	uDzm1i6e2WPVVBHd4Wbc+fLyWYUOqgLNHSnp3vJDm8x8AOsiFqGXF9MUttkA0IEa
	eouW4JxrO1aYzBN3a7u21O534ZSIJuu9NN6u5lw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:qyErXaUNoSfBuFl6tl6flP9cK8g9RJSj/ZR/bKAkC40=:0OINjBzUgfq3udtQxoCTHXGH+jsqc7bmQ47D4WpdvIk=;
X-ME-Sender: <xms:TjfSam0YbROYPNVfP7ecFpRYKYgYiKUWWWGZtWh3Mab-XrfHTQUvFQ>
    <xme:TjfSalATJp080vU3JdEPV55Unk55iZxUM86zlh031lef0YsOuTQpq1x8S5BUQiHs_
    opxpqK0AHN8BkOwfEVeRytSkAilxeT9xXDbij1pOjqkNTVlxFq5GJ0>
X-ME-Received: <xmr:TjfSalC1MQ9AnIT7otAxtCymFb7NsLwMFC0A567Sufm7SFMArzf6VBPjV20>
X-ME-Proxy-Cause: dmFkZTGXHfcSLLQdNmUBrh8iVg0mYe5Otx4TEolme1BT3Ui+/AiTgIVzb4+TEe6FzVwFQj
    psr4zEC5sqQkXAzY8D5ZGT5LvAg88fz6e4MY2ys09QnxzyG6IrSYcTsBWki0MGy23JhK2q
    zl+K8zxFdWYC1+i/B2TZYNHE3MFgG37Jwgbmr8qXYQjDs3jKlZFpNY4SIXQ0NlyexYUvBG
    lBepFWZBqfzPSL720Ucz0JOnCApwGFq1Tk5AdO2eUEDRl2jY4/QzDI8itJ16lamREZmZAi
    fdTOq4JHhsam1qQOyJYdmyQaSQJvgHb5axgJGoPYWDiShD54RmB5DkXZlLVfYNFa7Nvcfd
    4nBZeeYUw8+ckhzo5dL4ZWEI5R+go4pvNaytqcEZ/I8LcnPwz9e7d8izoiiX9dWYoI61b8
    9tKSOShgnZ5EFgnxe2jVSWsxY6t4tUV664w/XkscSTgI+sRrSRXnnHOMD/vf5BJ8RuQrxR
    Yi9iIoYITD6sLJKDIfk+6rVGVBVYIIR6PCGtt5zR5jJBXaLX++Ex1EH3I67bFM6NvG6KIp
    CDuBmPbBeStRlP9edKBOXakJ2UPV+cYu3s+6UD9R3JaQOlR+9aWAsPxazFtG0ZHcpc0dUt
    ejhfEPX2+oJtg5VeVb/xrXx2jb6g6iWXYmP6/2wk7FPq7TwHd7bsSa5aJO3A
X-ME-Proxy: <xmx:TjfSauPrdclSOysNh5lPcHwPFpu-AgIq8N4ZFrXNV-qMxLtC1b4afA>
    <xmx:TjfSanMUJxXDfOXS57dWhl3osncdfoR6X8wpuQDlL-Q08UZWFXFW6Q>
    <xmx:TjfSaquiL09tv7G0rx1DbzB38LVDLgd_v8dBg9h4DyCf8THjBoxk9Q>
    <xmx:TjfSak8EsQ2QXHxyD15RbhDDDqYVFBKUP8S_i6s3b_mUa_BN_a-3Ag>
    <xmx:TzfSaoBPvS7c6nIP5WWGSbmkkhBCMFeCdo9EGpZCzf2ynBIGkUAZ78aE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Oct 2026 10:40:13 -0400 (EDT)
Date: Fri, 16 Oct 2026 15:40:12 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <atI0edrmeiRuRtNQ@thinkstation>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
X-Rspamd-Queue-Id: ED8CFC0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: dt5nxc4k186m3wjucmh7zhsqmmex5is7
X-HE-Tag: 1792161615-374138
X-HE-Meta: U2FsdGVkX1+FKU/xy9BfkxOsHUQl0YUlXkzSa3eVUgJrZ3Q4sLIluo9IBde02/5lgy9hkBaruJ1oDRAFykPK+DHN4ATaZGYoF/6JETndesKEKlWwih8Att43eGkzsb6G81wwy9YKYl4JtAKNNgRQq5sIqG9Agw1KUMXV5hPl6UQsA6o55XGCSjtJdHkDiKCUGUaeeusW/VUMI+hxA/36ExrWqbxprO6Up5w+5lol9ystgEI7Yeud86hVdG5n//qS2JF1Tzhojry9PeWbCJShutYcTzQfNhGh0VGldOUMgntbKyox7c4s+QZU34FPkbRLsELA/cggKm3g5bEb1vRoDFSE8cCZcZxpJk9sMeuQ/19uRRZOkk/QOVfPhjxoUg8kCzBjRooG04L3tARE32L8/TLRnJGmiRIr7cPcdsXRoUfDV0pg9XnPYsYFwLILiiYOMfa9Tu5j6nrBGxPqhFb2/EFwzjHX22/iEJbLSohpLF77bUqr/eyssRhF8FlgsQ0YMTF7Qa8AZHjKV8IsuzN9EyTqwoFSVN2DcGVkBiqRn5R12nz0fEkQQJEo/fjTlk/G+DhZqXmyKgHzIyAC5NuiZCbqche4vSUkhR18iP4ii4IEWj7rGjRO/qiKTCHGJ7nOu9iOnbqbH1ow28QSq2Ow1XuHl7myBxSEGztH562covTPb+4NZQw/YRuJEeqeNnt014nV7G96OGNVB4pFTscn2wLrt/rJEAKdMcL6RqWeLLUVyy6Jlqc6pRdUJkCSF7mXhvPVI1Y7sTZn5uc7BouwyIlehCZ2FHbovMiNYdCoP3gRO1pH2K6sePYVDY4EYnIy2ybE0KQm5sDl2ki41nUYeJuUbHB3o60DrOcpU/D5yP0yTo67oJgTVgwKKD0f5uZ19qb+1tLVcHN35TBi48Wc+P/1+VMWZhWMC5HplApFSC5A+XCG449UNKUc+Q7n6nWKXoeg/Cdl8NtK8dpxb4x
 /1nlDyqL
 KUmZm8toPg45aEki1XWI0vamz3ljs2o9wxBPM4NoXrQUFBOYpmtXmgXosmaU8KlrXbXTDI3JtKVIXDEbwgDhGDvr5w+iGFs4Tl2PjkiiXVUoS95pRYiTG0RKrtWE5jKgyYD2L1O6paMWR4qZG+HCxgLV8dq+Fv6P00XCPd0y3sdezwi6aPSm8zFjTfYiKJnEw+nr48tn3dLfWqmt/3op4tPVGUP3BljWaWHbZJQnB5+IGIT9M9iZmczjCDziECCavLeDVFyhJYnqo9oDer9AKudw+ZIIth2pHB7WkaDc/SPBi2/rM54amKbouVEETXjnfXVx6NqWQQHQl8FCoiLzNONiaX4zJFDZXFNnVpqUK4GqbGFzx4tdfFGOeY+n7FerrjEbcpp0xxB1GyG86jzkXSclTOOfYOpgD6UeGNyPURZ5qVs/GdAyjTCPNjAIFZIEI7TrI6MybuJgefLPVlPpj0PN7Prm78/n48cDvWdI6utbdLDXCK6ttQZd8lB43lFjxGZuFhqIQhOqmwZSF/LBv5bv5Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 11:43:14AM -0700, Linus Torvalds wrote:
> Comments?

There's a regression: the lockless read loses on large reads from large
folios.

In a 64-vCPU guest on a Threadripper 7975WX, 1 MiB reads of a cached
ext4 file are 9% slower from one thread with rcu-free-v3 than without
it, 64K reads 4% slower.

The reference path looks a large folio up once and copies it in one go.
The lockless one walks i_pages from the root and calls
copy_page_to_iter() for every 4K page.

I've added a cutoff to the lockless path: if the folio is large and the
read covers more than four of its pages, leave it to the slow path,
where one reference covers all of them.

		if (folio != prev) {
			if (!filemap_read_rcu_can_copy(folio, index, *last_index))
				break;
			/* Many pages of a large folio: one reference is cheaper */
			if (folio_test_large(folio) &&
			    min_t(unsigned long, folio_next_index(folio) - index,
				  DIV_ROUND_UP(offset + iov_iter_count(iter),
					       PAGE_SIZE)) > 4)
				break;
			prev = folio;
		}

With it, ext4 1 MiB reads match base and 64K reads are within 2%. Small
reads do not change. The cut is on the folio, not on the read size, so
files in 4K folios keep the gain on large reads: 1 MiB tmpfs reads from
one thread are ~30% faster than base.

Sounds reasonable?

I've pushed my tree here:

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git rcu-free/rfc-v1

I'm thinking of posting it as an RFC to make it easier to review.
Objections?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

