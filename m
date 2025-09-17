Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ABF2CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F0E8E006E; Wed, 17 Sep 2025 16:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14F38E006B; Wed, 17 Sep 2025 16:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52268E006E; Wed, 17 Sep 2025 16:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C24888E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:34:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DC5D1DF92D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:34:39 +0000 (UTC)
X-FDA: 83899895478.14.7EDF099
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id C89B7C0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:34:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pXM2EaFe;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758141277;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2FyUTSryb04l5gvAh3w6KlExZLY4l7x5oIgcrw5oM0=;
	b=6y0eI0EGOwnACM/MdAWuXBD+XP2GjAXB45WABcUFZsRF7K8zoPsjIPRYnefAFP/0AhuBx1
	MOa8WJZKnc0IiL6xcNeIVloNmZmXtUeWpmsMJbhom0LNl2KADpKZ2FkcQOKB4/bfQ/IK05
	awa3jggjqrDn3U++SyXon/H44uh/o3s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pXM2EaFe;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758141277; a=rsa-sha256;
	cv=none;
	b=CEd9bxWVf78Y26/PgPKrlmCUFeIjaFw2yyshgLPdFV4Gi4HC+XoA68QYRS2VOIz9ShoFBd
	jXll28Qqybn3Npv8XbAc7UFqUabFCKXhMkwCUMOE9DQ+9ndY4yLFgIWcYnSecyD/AU5M2c
	CrnR8NPOWnxdtS7byiQauhap6LVWomY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i2FyUTSryb04l5gvAh3w6KlExZLY4l7x5oIgcrw5oM0=; b=pXM2EaFeZioAqlsirFHgLLE3js
	Y6ZdJCSBwDng3gOcV5WrmK6EhVOHSK4rJmZpJ51Q2DI8/6SQUpYlrYmV5VTZd0pbu1v5+pd1W+kXn
	DjAmnWP6aELjliaJecTwfU0LS3+eR9EwDBl5PaZ/Ul8mWoT5gfh8l7J+tn/7CsvdgkazhugGbKKP2
	uBFJ84s3j+lPkoWBivvqOnnAHKopZTVqkYVyIKLduQOtNYdFYmqcrrPtMuwNtHHNE6cAv/0QSWTn/
	GxWvdnPe1vccOBexPhYIZTogN+P/3pofZt80l5aSeaLDRtnFZsRTvxhLCkJ2l4OMS624z0RLgm7SD
	hD18Zszw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyyrL-00000007w67-1w83;
	Wed, 17 Sep 2025 20:34:35 +0000
Date: Wed, 17 Sep 2025 21:34:35 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Max Kellermann <max.kellermann@ionos.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	ceph-devel@vger.kernel.org
Subject: Re: Need advice with iput() deadlock during writeback
Message-ID: <20250917203435.GA39973@ZenIV>
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV>
 <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C89B7C0004
X-Stat-Signature: c5cqbwcofmhcagu9imazt8y69zcuzq5m
X-HE-Tag: 1758141277-731470
X-HE-Meta: U2FsdGVkX1+bdJ5U05nPrJGDae2eiG+3IZDr9f198cgUWSJzhm8qYi2wCxPEvqynlIZ1JsYD9X2gnOl/OtTB5HwU9EhWCob2yGrLHKSsV/eIImhgG5QPOTMwserhyitJpMCa3wK+p+R8N7x8vGqZ3eCda/kOgfLoQtRSSnCG7006G8mqUlDHPlWeMvsx0vYw3TSpGKcwBgGIskBnk2f+cULA6vkSUw+1dhsEHQDvxNRfzO/BYJBiECfFj7RppbgO2KMgZxg+Ggi7pxJaPZiI6QQLb3KwCYC+deQh6Xu7PqPopN4VM3wFgOH7h5DxD0tLnCD6gwqM2fegYDXY4meyxPLyFmV0IAQbyRKxAoT6hz3wW4amNaznjoc4ssM4krjnT7fHvxsoTlAjMZZ+IEmY0BEtHGJttxWQJzVbi5RiqKBYdgz2ho74Lki/s3+ZWeaER9TD20saPFaCqukSV+v/35NMCWt5L9TFbrpqPUljaDfm7Gor8xdIfw6xQ1AbmOiYE0lP1bvZnODoUMcBkJ7z4f0ytw8Ehz/pWu1YjFE8A911BaJQ2suOuBHnJ4HWlXDs23hTh/wnv/Ak/50pI3rdxSB7LsJHnkXeUA8QArWprI9CWL75EcifWNKypcvwrTMaoKLHZO3tArYP9CMQRST9zmBRsyOROw34bewQQpPEg3OAl4QRKU2pXoK2dHQFOuW8LWXEp53mzFBaJB2LaXKBxk9feioF9C/qt6kcbmTA6aYFyn+shFjdd4wutk90ELZOC2671iEuJEqhTAZRhZYqrNddMtSXB/FPVHv7gjJQynas1bWR3E9bSaiXTMprtAKLvK9ClK3kUC+vep/H4s50YNBNDj+UHKadXcqiDH60Q86z/P5u9jHY9nDe4QZ9OkmKgaIUveUf7SFeWiAKcbg7qiGB/bAzEZ5ZgE5rve5FFCXhXb2mvzR9jmy4LQkO12Pa6WReJSekg/uuTIT5N0L
 ElxQlQbH
 tk5AJESf7LBoVpksWXLEIaE8pRBXfM46mlY3EqwCMizQDxlIWfOeylmvRE4Y/rXpxuSPmjXM4q1xpzdOo47nWHC52RrmJk4bTRufuAFnU+q3mzkepvHwk8ViPclznHQ/SVt0QE7ue/t/uOCxTY31zKYeQK2f57FKLDjYu3lG+G1weMjX9yivg4Drfr8DO+QbO6AsZkthc4vEHdYNbXs+DBMINwJiKwwwM7VWt7j/DxQPnB3VJy1K2S1t5bccWnqXgORxUT5CfsHHn4feiONM5FW82QfR9dlJYEEawijMDmRxQ1cUmShI/u8UHkzj4myASeGOjNH9jLV59FmYv2k2fLoSrGLJaUIUnkRCVTLdCiVSy0RXUePB87kBjyp+UHp1xdNy2rCShPFFjugFpCzcQ5kUTmS4lGyWbxw+4UAv8NpHWN42aXKlPMYjG/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:23:00PM +0200, Mateusz Guzik wrote:

> This should be equivalent to some random piece of code holding onto a
> reference for a time.

As in "Busy inodes after unmount"?

> I would expect whatever unmount/other teardown would proceed after it
> gets rid of it.

Gets rid of it how, exactly?

> Although for the queue at hand something can force flush it.

Suppose two threads do umount() on two different filesystems.  The first
one to flush picks *everything* you've delayed and starts handling that.
The second sees nothing to do and proceeds to taking the filesystem
it's unmounting apart, right under the nose of the first thread doing
work on both filesystems...

