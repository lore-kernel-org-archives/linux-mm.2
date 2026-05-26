Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87136CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDB66B0005; Mon, 25 May 2026 23:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AEB36B0088; Mon, 25 May 2026 23:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4106B008A; Mon, 25 May 2026 23:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5EE6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:34:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 748F3C124B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:34:13 +0000 (UTC)
X-FDA: 84808152786.13.964A5FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D60CB1C0007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:34:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ox+6z2Bb;
	spf=pass (imf20.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779766451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzxIDQSSkfJgeOWIE/b/66yps/8QKZUf6btX6QP9PLs=;
	b=W6kUUo798NgddIHCw4iCNsD409dzViPbWMaGg1Hlrduj36sHMUMHAa9xbELjB2KDEe8qrs
	jLsgdbJf6avVfipQUgp+DsMUVDrOfHayGErWf30zCxS5RQUXOlUppXcMqqUg1YO3IRKBq7
	9Gu5HdhHJtOPv/RjFRn4kLqt9dCgROA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779766451; a=rsa-sha256;
	cv=none;
	b=Bdnxcx8gwXIj3DCtzDe2fUIhAPTS4yFXoyeM2Wz0QS7dXuKBlbgBGPHQ3ah8oEB6MxjNMA
	r4WpXVdU5XTQqK6VcqkNzRpzc3a5jzVo7B9eXMMr/+34W1tsIe+p2bvlGdegX4KQDVme3T
	PnaiV3aCC4/m1vSVdRtpuL3Q4pVo+qY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ox+6z2Bb;
	spf=pass (imf20.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03A744013A;
	Tue, 26 May 2026 03:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D83A1F000E9;
	Tue, 26 May 2026 03:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779766450;
	bh=kzxIDQSSkfJgeOWIE/b/66yps/8QKZUf6btX6QP9PLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ox+6z2Bbjg3Ky/+rp0Bm1D+6MC26KlSfeMtVH9uQjXCZSGA9a5fpcM5Le8m82mWEI
	 2Ww0aMuvq88M/TosuQf9mS6uLWIUceeIN+DjUZFT56jeT2NHNjY9jp3E3LCHVoMgtt
	 rkmSLKjwU5fGSkFJm8xHevnqNl0DaAMktd1/efGifsG2Qe9RgF735AFBuqjJOxIsHv
	 5eUXkfiRT319JXGDS0KRGF/oHdzCvyZ/LJNwS9BLfKd4k2vHiKdFMmfRp/Npm4UzMW
	 crbIBM8hJO6QnAZTfWdtC8jZxzEBkVtJ6X/fk+sW6mle9oBXOPjE6ZGtjTZMW5Y72O
	 cZ8DmHAeH8sDw==
Date: Tue, 26 May 2026 03:34:09 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahUUsXZS6FN7dr3M@google.com>
References: <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ahUG3ZCnc1RQ0EL_@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahUG3ZCnc1RQ0EL_@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D60CB1C0007
X-Stat-Signature: amyxzzbm37bzdnrru5tpqwoy77u3o7se
X-Rspamd-Server: rspam06
X-HE-Tag: 1779766451-700012
X-HE-Meta: U2FsdGVkX1/L5+yMuCIhyeXLzQOeWsZhWYxMvIlD+EeNu1bMSj8v+zKYzpAa+6ZwdCxchJdBm9sJXiuRyDXi9bsx61EA6mdqkoBu54q0JscTBCrofngY8fNia+uuM2vcVMtu/ofxmmXc8+eUInmQnDkIVuLn5bdgjprQvoM42twfNY2iDCLifuLxrJ9syHzqKHdRtQthmxZytZdCpuDyM8Wh+amifX24uzEEGOUTGlxCPFK5rnHics9uiClNkULHKu6K2bPMtWtuwTWii9rDi/HhHXqVgY8pFyz7YbfsUNnev1p3Yfc6CRgJLOANtQUqm4sj12GwAW4d9P8rQOTdfuvcD8YV7cbXEQDfFIiUzp2yRThTf6cJdBaVEN/s6zK742Ulvyii/bk0JbOcKfYWtLXo7j38s97eg/RqgcQ7ITMe4YYQ077PpPuCValiRbAWgKsu6iJGhVmDO2+9STip9W0RBQW5GRaYlAvg1G1gv9TPvNbHa5jYNaR9CbkZ850wJDRa7Wyqj6th2GxaZUAsRzAiDpmwXkXE+ItXfTnFonLcfZr7/TnOBT4jQtYC4H6V+i2tivkXv1hubNBLYWPvN92P2PYQgfJRyNgl1HkIVx9iBIe6f28my9vfOFJk1r50W0yXgKp+jewoJXpIj4DyR8ya0qY2BLEhzbNOeC4Bg0a11P6PdEMQFQdhMTqZyDASrRtKke9imnzcfVjKsVcZaDZAjCSuU+QmHY12H6Rzq3IiHYZiP1jTRarbdvyJTo72BlPRJMRV3XZespl4EM1AqzZ4vzxo37lxXxsdEFfwmDgrkQngnUmPmmhWE4y9Vk89hkSIEFoaE10Dc8agl1AR94+MOpf2VbTqveBpiykdA6ZqF9LMVsnsmTRFFJBoBR5pwP4I0N9OIWzx2+KNIYtdHC4etNETqB2YYv0nYXf+518bc92vkmckhncD3Moh1yQNEyfww1w6432lJXf5DX1
 Tj9H8/rw
 wvCOU6iAcEiYZt3+NYPtcfhzgBPFMmSwalsEUGY9YAZ5q8wjb7mENHNay4IEsw45lM7V0tQuNZDlo3c15Vyw/Iczjitmk8GrtcI0AfyrDMkUP5gdbCsSG/xNu3iTqDCaQD5unZYsixbsg+KeIXCx4/vRZCHOGAunxapPBQKhinm+J3vqW8OoSKGu2N+ycYXad5pJ4+eNCNlu2r+3DVo6CTTFHIQ6CoDsaK4S1cmrXGVOk1qoUvDyPqZcVrB99EgLsAEj/90Dz7KVCM2/mwHlwxplTYd3I+xpZ/d7lghWn/nr0YkfpTq2CbGviqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Matthew Wilcox wrote:
> On Tue, May 26, 2026 at 01:10:55AM +0000, Jaegeuk Kim wrote:
> > Let me try to write more details, helped with Gemini.
> 
> This is garbage, and frankly disrespectful.  I'm not going to argue with
> your AI bot.

I wrote down all and they rephrased it a bit. Which points are you feeling
like that?

> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

