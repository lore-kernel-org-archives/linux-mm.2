Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5AA0C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E0F6B0099; Mon, 29 Jun 2026 06:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56116B009B; Mon, 29 Jun 2026 06:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B126B009D; Mon, 29 Jun 2026 06:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0BB46B0099
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:35:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B16D8FF1C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:35:51 +0000 (UTC)
X-FDA: 84932594502.11.2CF1CDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A2EB51C0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:35:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKa10FBf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782729349;
	b=aDVNxzyoUqF8iiZ5N8IC4QJ6KawccYFnEa2Lxfzuj7SpI8sPukdx3R6DuqLlJTD4PBKkm5
	lGLYcZpZtaPicE75nj8Gvbfc4LaQLaGQaaRh0X73Q+C7Dive1I6Zus1+XsxhlZ2AC32koB
	/fLA6vPXT6bR95zlotE8uy6hJSY2Qz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782729349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZKEgsAeSbUFcWNbYqqA+tqAigfpU6kxFl6/5tR87ig=;
	b=bahZUHxngOGtYyuTfdrHwLGI9CaCFndDTusG2bRWUoiF8oUq5vFxqUhBD12gG/o638ZMec
	BzIgq8mIW/Z1qPak727ehyzo60+MLSv6Q4edcWU1RH+VYUdIlZW+K4/3aZubaSxri4DqY9
	UYDK6YT2dKjYq5zL7KycrIHrx16eCEM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKa10FBf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F05FF600AB;
	Mon, 29 Jun 2026 10:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1971F000E9;
	Mon, 29 Jun 2026 10:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782729348;
	bh=oZKEgsAeSbUFcWNbYqqA+tqAigfpU6kxFl6/5tR87ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKa10FBf0Q4RGAZAmqjlC0fIa+dP/+JGG7/kE4axKXYgB6hT9NCUClwF0SqLSUgiw
	 0ohRCRkT0gbZKnag0Tm94xuSWdRL9D44yPjlcmP9Zw1e4Jy+EW8SZqZOoZe2mnr0mQ
	 6h0sabOs9e8zOTT4g42Q8HxSHZiEVhO/N5SO+nILifZyWNxADGkCbOiGJp3zCy1IH+
	 dsTfu+8JafH0SNVpLac/SPfCFC+Li0l2ifyeUqi3Uux1mapzsYMOjkDQm0hcQ+T63A
	 PmBrOTU9B+xw6vnMlDZGW6yzSunCDQNSfQ0MGHHmevPBiqIy6N/qYY2IJba3A7LdoM
	 xYwt6sUiE4jzg==
Date: Mon, 29 Jun 2026 11:35:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: kernel test robot <oliver.sang@intel.com>, 
	Frederick Mayle <fmayle@google.com>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	Andrew Morton <akpm@linux-foundation.org>, Kalesh Singh <kaleshsingh@google.com>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm]  7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <akJKSZQTvnUhkMWV@lucifer>
References: <202606181547.617a6967-lkp@intel.com>
 <6z2rqmo7b6m2rdhqurspwya25ps4dj7lctdygnmq3rn4xt6h3i@57kiiy72epgd>
 <ajP_-zqVPtbzvc9j@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajP_-zqVPtbzvc9j@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2EB51C0005
X-Stat-Signature: s9bf85aj3poxn5pspmp3emwjq8gybyz1
X-HE-Tag: 1782729349-793672
X-HE-Meta: U2FsdGVkX1+yjaIDixdGNtMP1ABcqRF8TCckwEuOjvwweH1++LWe0k54qXM/ukJDpGA/tC1pGVcpG++i3bWK37h4g7jTUXQfNY6JnzLRyyion+RtaKiZYOBOwhtPNzywpgmP9PMDX4rT+Iz3i1vADSSbdHHnckIUTea57QJ8PZ/ww97ql8fQn9CIcTsvHcjiau6UpyzPYT/EJgRtDtBYP7EHkyT7h0hDA76aYHXDXV2W3b8qccD7pXBpoLYLDhUV6yYYoUoPacd2Ukx6ueAyFk17Yo/UHMxfwZkiYbwfIUTNSad2yDyMshM9q9FlVSHHlQZUEeYSMc1CzvSCt6vP3kR8vmZqHQXXrViYErrBIHl6x+dmY59AY+wfSXYmKKjDoO7Iq+Mn0nSsacu4XGLYgi45KX29iwcIKTDfvoLlfLZR12c9kESQcsSB2NzrivczqJQ38MDtW9Qp15cEtcQyVZ6kemQ5c+D6AglQeSE5FOaVpJXnsoYICpoYmAqZn1RArbGgewwL8MlXhYL3QDraoEfm+oHdHTsOY2ntg8rzf3Evy9ZIGOiaLC3ak8Sf5/w3vmlWmFBa0d8Yx5d0Rq4OqQyt7N/2FELLyMnbiMz8hJkWOynnjtJuJ8SG7Ux5G4ehc5DvlBUPy/unIjtoyGglI4zwdc8ZaqY8hEPJD5sBMNjOJxPakCG25D5bK5C+CkuUgxK7af0uAd54ysNBcvw/GW8+rqyvzImo4jUqN1Bu8McQD63ywpa3uk180YM79nZUSKqk26zJ70s0PhpJZGoTZtU9/RQb8xPBv2zflSsTCltwF97CXN607d7AtWZoDOyFPfxFtr6GQ6J5QzWuwgRLr+0Td7yVk+AUOLdr937T8UE4J3A+zXwPlVn/m2DcCnaNBMxxqj/oTbv52HA6MsEgoooJyidnayPWkcVaIjwczem+V0uRxctB0YkEBJICiIe9XUkEB2oUv7i7jYKwPEO
 OA8iZoVn
 jN3HgLBGJsz1ajY3rVz5HpAHFtmJqeQc+JeoysDQeg+/Zj6dRaj5YmaQNupc0ryVqbfkeell2JlGsq4oGzG/vngXYeOz+v5fShDdnTHFBxw0kgviuG3cZDvTl6cgegMzvZoqMYNkhdlySmsOa/SV/qRj+MrUaPPygOnP3U8kXDyN0ZnlP/616rwm6SjpNasy7Q5NhITA2wMXSmZmkHk8KAPzKWcel9FuE55ZljocigRgoHi2m5x6DBu+f3f5/pMGbfhCbLqseujhQQqLtRYvE1VjFFTFrBJsFoG/xX8ux1XaBb6u4BdWWocumrQmbWuxyokxxS1ycG5yhDYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 03:30:28PM +0100, Lorenzo Stoakes wrote:
> (Sorry to be naggy buuut :) - I see there wasn't maintainer [Matthew] signoff on
> this, we should really be in the habit of _requiring_ that for merge).

To be clear this is no comment on importance or not of review - all feedback is
taken very seriously and I respect Jan's opinions _very_ highly indeed in
particular.

This was merely an administrative point.

Cheers, Lorenzo

