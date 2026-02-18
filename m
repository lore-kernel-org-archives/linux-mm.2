Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD21E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 06:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10326B0088; Wed, 18 Feb 2026 01:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA856B0089; Wed, 18 Feb 2026 01:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12286B008A; Wed, 18 Feb 2026 01:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE6CF6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:51:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7495AB92B6
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:51:12 +0000 (UTC)
X-FDA: 84456655584.04.C3C2BE5
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id B56A3180004
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:51:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771397470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hhHp8IS7nlueve3lbw27wdUZSkVXU0vuvaHkQmF6g0g=;
	b=WKX28m/PjCwEVdFCvEkBxRoB2n8lsJTZz5/wHZFMDZa3eJiGqK4SIKF43DdEosQ3eUo0ze
	Ht6jKK+ZOr26y2LQRiPYfgeawUkPQ0Xv29+sqQ+8aZoqb2Ks5BmHB9E4kPMS86yNA5Ey+m
	bJssDFDF5tEFiOVnHOwsvzPs9uNhdYM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771397470; a=rsa-sha256;
	cv=none;
	b=36IP3VnwZ7nsM3Q0/AoM4PCDnB2xpsFtSY1WuxgVMcQn0nCm+7aKATkb4KoRMi/RafwSEQ
	YG6K/AbG2QqrLCy9K2B6hNdDOApoUyL1dRrwUpeZh16A9lFI69AJJIHPyNbfwgmcGv1NxQ
	jNjZ8oMSYoVZrC+wS/aLmUckknb0z2c=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 94FE868B05; Wed, 18 Feb 2026 07:51:07 +0100 (CET)
Date: Wed, 18 Feb 2026 07:51:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Pankaj Raghav <pankaj.raghav@linux.dev>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com,
	jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260218065107.GA9019@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <20260217055103.GA6174@lst.de> <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: n5tp8o46odjzarwqno4eagn6u3amngfs
X-Rspam-User: 
X-Rspamd-Queue-Id: B56A3180004
X-Rspamd-Server: rspam01
X-HE-Tag: 1771397470-182228
X-HE-Meta: U2FsdGVkX1/InglyOhMPtdSnEX5Ywen3GFcZJn0foR1rcft2H8cdKpAKxWZQ2FVI6VZ80d7CCmjULIS3AfGLKHB2WubE3zIW2s9bkVciC7c47HKIFCASpe0hkc2JJ0KpKh/RGlI36XV2fvxW9RRKPdl0ugeBMRnkc5/RnTsFVHLdo96MRucqn4RHB3IOnLgxrLWZb+VjoeeDFlo9aPUXkQXke7u5Q96oErOM5T2YyGPhh26TcWFKdrRBEFlIPxC2SbK59okbRILFuxGxwvkmJEU96qWzQc6vlqH8sEmbhdM7mLOQea9iMiyx43sKLUlFaX+naGkbhc0VP2MwSCEzuzBRx9OAKvOF4I5JQG+yIsNQhLNatzzbHKXrwSsuwwvYmhmW5RgF79Xhfzcp7RdkoHrR7N9WZ9tJNrwTVGytDgjK+1JiUtcObuCVNXv64/Yuun7r0K96vW5bph7J4Y5D369Pk9whOUSe1kHmRv9S6dg6+gBnaQhMBs4hA77LO2PXMiHfYUAHbNXcEJxUUkM3Uu1hFVjkUYsEJQBK1rr0cC5RnUC8B2fYB+72YkJukkWH21e/A6Sd5Cpt3FTQAEdNMYEABJVujS0lMJJaCw+2tiOi9o9eveN9NDE8HF/1BnCEfO+X8hFnjxTUCGTQpQHn8zoBkz0xxN1y6EEv/TZ+qfN2eGDZ5wg3CfQSfKHGeBsomKIfOKKVZZT6Xu5S8FH8QfEfwtJlywQaygp8HFV/hLAMCC7AhRXODatttPTjDkzmPQigL0r6vNvZAHIb30wJmbccJ3bSIeyACwcd3v7xg6HsRBw5ErJkBdeNRm/bFe7oBJg0VO/Zz5F8dkqJ7lPlrOtVR9Y4gkqUfJPAf1C6ohAHFKVVH6XNtt4y8Vu/P1gYvw+MdRfwqr8sGn74A/K1NpYNtuScmHqTSlW7wR1hJq+RhVe58JmlgmomwoNgnXMUCApDWSehmh/zpiiBDsd
 lZiwTv/d
 Iyf80Gaqr90WSqVWYP0deBETt4EtdYLgNW+fQ2zAqfZXmBt7GQClbLjCwB8UxdsxnSyrbDt6Xmwtu3eURChvvNxxY5CopzProCTZ/CiFdkwROEnmyzlWJo1Hq7Lar1Hlnnmy77jozMAGUxeXcfaLhT/UpyLctv9N7Bpn4Mv5bnQfe8xpfiAG28tIZpoCx36TqAwtq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:23:36AM +0100, Amir Goldstein wrote:
> On Tue, Feb 17, 2026 at 8:00 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > I think a better session would be how we can help postgres to move
> > off buffered I/O instead of adding more special cases for them.
> 
> Respectfully, I disagree that DIO is the only possible solution.
> Direct I/O is a legit solution for databases and so is buffered I/O
> each with their own caveats.

Maybe.  Classic buffered I/O is not a legit solution for doing atomic
I/Os, and if Postgres is desperate to use that, something like direct
I/O (including the proposed write though semantics) are the only sensible
choice.


