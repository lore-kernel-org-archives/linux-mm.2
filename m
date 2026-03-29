Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2ABDFC97EB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 19:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95556B008C; Sun, 29 Mar 2026 15:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46016B0095; Sun, 29 Mar 2026 15:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C0D6B0096; Sun, 29 Mar 2026 15:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8797B6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:32:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 204A714044E
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 19:32:31 +0000 (UTC)
X-FDA: 84600097302.05.FD930C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53A8420007
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 19:32:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncKYXgRy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774812749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWHNg5WASYXdHJ8v1mtZ1guFxNYNpTDcmM6UDJ9kZzo=;
	b=xG7k9ySGzmd2fPVh5ZkmfHqQZbxlbKN6ZBMApGkjdsqRuxpU2D2UFgb7gEvlREe6zQgB2+
	EFTBnQr4wF3RPJqfv/7BVQzvdxng17y8Mi2QNH+2LqqigiIax9HtZKaH20kLdfZjpm0xPH
	qUfaKU+WrYOGHq+AjXWCPSNrFCp7/bs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774812749; a=rsa-sha256;
	cv=none;
	b=2bLThaz5LzGeY6axjx150KGTUJGEjDXjlWxY0wjry5Ds93FaJxxnWP7lw42biBrotx29WB
	Jcf4/hXjTLWDrKQkR85RuHTGQDjQQpny8fnRJmb6X0DzLMaEIHVCoDenOpBiyTXKoW5exj
	0jgTF/332YqzhY/2tQ3EXWLvuazAbfw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncKYXgRy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30BF24419C;
	Sun, 29 Mar 2026 19:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD943C116C6;
	Sun, 29 Mar 2026 19:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774812748;
	bh=GidK0k6cqcWgrzXgE0fU2eP8/imjAJ8bcJ7Zp2Lqr5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncKYXgRyzWHynpOrDPnHrj+O6t9H6BeAxrX059m1yw2sgIDmrmPGb+/TUNE2fRvWn
	 O3BEIdceoCWej4V7yLD6l6L6Rm8anVlCQGTp/1XQA9w62BAbIGaDRetS8IuFa63p9K
	 IAo4yIe5dX/iuaqQHHuVDwrBwxm/Pf9G1XaDiil7YbwGsC6StWtGDwjYHOV6x0zTmd
	 UVL4f7889EAORb/JXtscFG/m90EQ5IAeVKOjrAUE3ku7oFPBJTghiQx5QuqBGX55iT
	 F9EyHtUY3myDQewG3geUgCzNu8Heb9UTgKPwKsRMTltmEA6pvtFqgb4w6xtXBRV4KY
	 fUoxN1oiV5pJw==
From: SeongJae Park <sj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Sun, 29 Mar 2026 12:32:26 -0700
Message-ID: <20260329193226.59025-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026032915-library-embolism-b48c@gregkh>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 53A8420007
X-Stat-Signature: frsqcqf71j6w5d13odz9eewmcz47rfot
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774812749-295329
X-HE-Meta: U2FsdGVkX184EkzFjB+nDu1UPfuwJWCroZzPauT7xsv2VIueDGgs9NUGPLgc8iOJt32zIAlbjB+fTVNYQq+VsbwsaI7tiAsMwMGn1ZIFSYk4qyRrpYuN3ny2B8kbNNKJepAlSPaxbKS9OO4ZxBn9oRRz1hMlRklyTHUe2O6ECzlObTl071mKPlFKxvAjKc4otdlpOUognpkHpHiDIlp1CqRCbdyZX95Zotb96QSl/eA2VcqcivgAlCyaFbjg+qdMBLXXLrkRfk27fpCTDrfSyIQAMyfaw4O0JB4uShn101qt0hYa4W9aZunJwYX7xkVzkpdYTWd3kBl2hKeYPHpGqf8m6cdP5NKS+YosYo6a3EzVn04V5s0LdgPb2N5h3eA0cfJJtl+UB1IPeg6X9+bzY+7n0Wt2HfSiESHB8gNe+grk8Iv/WYmbyrkj+Nfq8vIRUHXRYeyfQ1HlPXy586ww3a6tPhRvwYaW7kmBrXRHsi4ufMUtAqw8hLhl/t+LhSPZi5EqtKBbM7HsXdt80ql+3v3rX259ziaRr8gXvrAiuWS9L5q8O8vfZz9KPX5StRlLkwbYvGPYpaVSvLFDs8AwZ9JXMChbzW0BUxJhptCrWkGtIRxHc4SLiuk69qJZ24bnM5jrSIMMWx0P4lTd6Fgg68vKcN6JfVeSWoVzAxL8u/lycAjBCBN4oy/yUa9LWSHmrYudyijD2lm3aDK3msEgWtDQyry8NXNXJN/1I8Uztmqq3mqRWZVs3rNTXwB/whCplAlGX9cqbc2/nAP+yczqFVhBYxRLTTdPpz03Bx52pl+bnx0oVN5mDNvl4hIiS8CrvRc1wqPUX9LEr6b9XUsMqav8P151srrm5dhjb7QHr05Vau1Hh6pcqoTaVsWPiLbViDRWyMi5CmBaKGrpK6z4M5o20OMhlbtimcH5nhCioC2z5Tof3wwxyo3myvCChjjzwaeloyQA04TOPzVso84
 GCC6ELkA
 8h/mWAulJ4bm01fByHOKBXYbmkX6uDKMgeB+sawnOV5xB34OfU1YbQbiDvCjTBBu5vgcjJjA6KccwwJ9Lux5Kx0MSJCmfEV2ZMLr814AwtUgmIygaD2CfZ7JidNToemIAlKqMQyqVy9KlHP6kJmxJPAPmkKl+s5jM5KKX1pOAVPk8EO2iO1vWSOuC2A4ah+eCpNBJu2DMLue6fWn2u/AD8ykFof0CfwoTkOjEtirLNhOr4S8D+mFHgyqhpOgX57rjgwHojRBmXvXRVZN7f2RIDO1DtH/deIO9FTdLELusuzWUcrWumi3r23Rvwqp4je2OP16qUZvzWbToWncFJKkapKncmuCeNU4Q3RuWBGzjKVUi0xeXbLImhwIDZxQ31o+tpZM9PvybqIBKEIpMO9ipv8L6gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Roman for a case he has any opinion about my sashiko usage.

Hello Greg,

On Sun, 29 Mar 2026 20:05:53 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Mar 29, 2026 at 08:49:16AM -0700, SeongJae Park wrote:
> > Forwarding sashiko.dev review status for this thread.
> > 
> > # review url: https://sashiko.dev/#/patchset/20260329153052.46657-1-sj@kernel.org
> 
> Why are you doing this?  If we want to see the review, can't we just go
> and look at the tool itself?

We can.  But it is bit cumbersome to opening web browser and moving my focus to
there.  Reading everything on the mailing tool is easier for some people like
me.  Like some test bots send reports are replying to patches, or we sometimes
forwarding bugzilla reports to mailing lists in a form of a plain text mail.

Secondly, I have to share my opinions about the reviews, as many times AI
reviews need human's opinions.  There is no good way to do that on the web ui
of the tool (sashiko) for now, and I think this mail based flow is the best.

And anyway I'm supposed to share at least my review of AI reviews, in mm
community.  If I ignore, I will only make Andrew have to reply asking that.

I used to share only my review of the AI reviews as replies, instead of
forwarding AI reviews and then replies to those.  But it was
1. cumbersome for me (should summarize AI review and then my review; feeling
   doing work twice), and
2. feeling not optimal at sharing all concerning comments with others.  My
   summary might miss some points of AI review but other reviewers might just
   believe me and don't read the full review due to the additional web browser
   opening work.  Also some other reivewers might kindly review AI reviews
   before I do, and save my (or their) time.

Hence I ended up to do this bit odd workflow:  Forwarding the full AI review on
the mailing list first, then reply my responses.

> sending it back to all of us feels odd,

If this is polluting your inbox and/or distract you, I'm so sorry for that.
Please let me know if this is distracting you.  Maybe I can filtering people
who don't want this kind of replies out of the recipients for the forwarding
mails.  Or, if you have a suggestion about what need to be changed, please let
me know.

> especially when it is your own patches.

Unfortuantely sashiko cannot send email on its own (yet).  So I'm doing that
until it can.

> 
> confused,

I hope my above explanation helps you.


Thanks,
SJ

[...]

