Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712ABCD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7D86B0005; Mon, 11 May 2026 11:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78036B00EB; Mon, 11 May 2026 11:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E446B00EC; Mon, 11 May 2026 11:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B88B66B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:42:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67AA7C07C4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:42:15 +0000 (UTC)
X-FDA: 84755555430.23.FFBC9BB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id AF7E340006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:42:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eQnLgeqE;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrLNUPV9+W+5iFwARPpGhQy5+Ze0IUVAAWbwzbDM9Q8=;
	b=UmuE9sINwScKcVjy7xcyIwGu6DMsC5cX7+OqbxOdWx5nTO/0Vk81QJbSO1XbBrD15YaZ2g
	NVoRlHUTc0wR1h+bK4kAkrpKLy4KPGOdcnJ5nvpnCNAiL7e2Alg9m9qwXfIZdzz6ZlKk9O
	oP0e/OGGHPW3QcAzpibfPFYttMeYcbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778514133; a=rsa-sha256;
	cv=none;
	b=GpEy/+Ag9wpgXuYKtnppuB/BWPeuZie5rDG83IJOSoaopSwYsqQsujbkSTfOLNa/5PsgaY
	5ZiXVrFrWQ4e5v1hYogRtDzYOL2S+xWbXXm5u63zAa5otpghNX7eZShED2XL3SIU+omryz
	eZwhgc0HP/1ZDOQ7axL1fZjXMsjr360=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eQnLgeqE;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wrLNUPV9+W+5iFwARPpGhQy5+Ze0IUVAAWbwzbDM9Q8=; b=eQnLgeqEU1/WK8BzdVwICDvSzR
	Pwvd8UMjGhi8qnP3fGq/cRIWUQIXAfBbIdZUCQNmd/TKrlTZfUSeTy1AbdOERS7mHD0ugGu7Ov6Zn
	tjpxpSNKTl7kXmyd1e+NZQBbCMdmB8xyQyf4rDmS/avckEdQgRHO9Lk5RGpWelRVCxs50+D4gEiP8
	Vs+ETA/RsFbKCnHCEp6UGc2bgnKhXE5NFPUP1BRxU+MLwP0DBC/1HVHibmm76LEg/hbfEudiGcXRX
	//i0cDvp2kYlNBFg9SEh4Zj7fpNe7J1tlSArWoyNd1dfHue2ujzibYE+OISmqqmEA22mIe7xHq7z9
	dfZYrMKw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMSlf-001hYn-18;
	Mon, 11 May 2026 15:42:03 +0000
Date: Mon, 11 May 2026 08:41:58 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] mm/kmemleak: dedupe verbose scan output
Message-ID: <agH4girwVSEIMFAs@gmail.com>
References: <20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org>
 <20260508151729.682551a2b2739e8b5d15ade2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508151729.682551a2b2739e8b5d15ade2@linux-foundation.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AF7E340006
X-Stat-Signature: tdi5hkhrob458qy7qa318wwohm16wn1k
X-Rspam-User: 
X-HE-Tag: 1778514133-201820
X-HE-Meta: U2FsdGVkX19mlCxQ99V9/kCFixL1YBjvDXPJIxgvMxq8+xAbZVHdTo4ZpBg8y2WVXNzx2DaIBOLi0ulfMvK8L1X5UgH5oTHf8HY05cbcJYUz6t2c6sZZEElg1839PZj3O5BTY3Y2Q9AQroQ1iPjSkZq5H0Sjz4ysy2jdY4KVtkt3ZSojR46TQaEaoMGWM34cLDhmKF/Js3MnAMoCOtY9RXhARFeDgmVUpJvitQ43VmTG44nih3A3+jpwDqvPCR9HkzPPB38Fz2JoS/wwybqFxwmzkv4K3RyLyD4y0i5qIIVvQUE+I2ve8vsqNQdYfsvtPN3co8Wt6H94XJ5fiEA49adiJoNA0cKkB3t36md7yF6EaLsZBfpudzcbo3/tOsQoviyyu+WyDWExSf8wQdDq6g8LPz+giI1/BxIcrNwmU30PG/oOyoGWGd5cTqc5nFjYTxjntXiK9lRnATq+fLl3/5DlHbwe9tRSbTW7XTCVbmZZwBFm6dVix//xegAg813xlZUtbGLvkfzeV7g7V397qFESAETTVZjldoF48hWtqmjR1LmjEHrVr3WZyrO8bzrP8EhGsm7bbYsMQo+mTqxo19XS83twk57CN+txrQwyxZEHmzHyRUSQoiNTxDFhp+3R8Nfu7KzUZvuYeGIh4nIzs++38tDFKi21OBA7ioCMI79a5oGcRbpxdwe0GQxkwXkSYYX+BvueasuxM2f7pp7K0QMqv1yFkJiFbZQK4zfZVwiaiQdjPFtOsjOoYQf4zMKVbQTVd59zFB4iNYx1ba+zOkQI3ZyHW+VHEjflC5KMSQOZhmBUgZrR0AMIqcrCZMmnxsLPVFicZyuTw7rL5mc97z5Dk0ImBpSS/PyCkG/Ta6aaRdOvZhlkp10wsfY389LFjNErmCzlvBIfSFM4kAsD+GOw3ylJgtOCNAuG2u3DNw3nE3GbURpNWDndeNVUb1nfBtRPjgzkYqbz/8RyscN
 ehIY3j1P
 6nKlGXtotUnwCsgdTS4MwV4X79srU1IkEHEZP7yeAw0dgCaqtm9xdiMN8+eMOQNTbm5jTvyF3BQ14ouVvfB/XWy+J8+UgwvSs82ArOyhRN58V9U/rEPMd3OZz1TtJrcWDPWqhl2gwfOi7zNRI/LJG7EEt8wsJOt61DxLk9/fLb2sIJgIzZ7LHQuG3/NMh70IN2J0nWET7lA1vyYFmJradfS6MPH0uxFgvXi75c47l8Cc2vLOXtsU9mbdBn7WFXDs5fD3W3ZCp4ls/0pHWQ9pdK2ZmgsHKvMTPt9D8DivXM/uwRsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 03:17:29PM -0700, Andrew Morton wrote:
> On Wed, 06 May 2026 05:58:23 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > In this version, I am not touching the kernel code, but, just fixing
> > the selftest, as sashiko reported some issues, and I am addressing them
> > in here.
> > 
> > https://sashiko.dev/#/patchset/20260424-kmemleak_dedup-v2-0-8bea649b2a92%40debian.org
> > 
> > NOTE: Additional testing has revealed that lockdep detects a potential lock
> > inversion issue on kmemleak and legacy console.
> > 
> > The problem occurs because the function holds &object->lock (a raw spinlock)
> > while invoking printk to report the leak. This printk requires the legacy
> > console_owner lock, which remains in active use despite the ongoing transition
> > to the nbcon framework.
> > 
> > Concurrently, console drivers such as hvc (hypervisor virtual console) acquire
> > the console_owner lock and may subsequently free memory. This kfree() operation
> > calls into kmemleak's __delete_object(), which in turn acquires object->lock.
> > 
> > Although these code paths hold locks from different object instances, lockdep
> > operates on lock classes rather than individual instances. Since all
> > kmemleak_object->lock instances belong to the same lock class, lockdep
> > identifies this as a circular dependency, even though the actual deadlock
> > scenario cannot occur in practice (?!).
> > 
> > This problem was not introduced by this patchset/selftest, but, it is exposing
> > it. I plan to solve it once this patchset is done.
> 
> None of the above is usable for a [0/N] - it all pertains to the
> ongoing development process and should formally be below the ^---$
> separator.  Because it isn't relevant to the permanent kernel record.
> 
> The v2 series had a nice cover letter, so I stole that.  Please check
> that the below remains the truth, the whole truth, etc.

Ack, That remains correct.

I just updated the cover letter to reflect the changes, but in the
future I will keep the overall goal of the patchset.

