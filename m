Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80418C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 08:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B456B0098; Sun,  6 Sep 2026 04:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9432D6B0099; Sun,  6 Sep 2026 04:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882AF6B009B; Sun,  6 Sep 2026 04:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67CF06B0098
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:28:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0680A1C21B0
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:28:18 +0000 (UTC)
X-FDA: 85182660276.05.BFA72AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73503A0002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:28:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhGOi3zb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788683296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TSAAf7dKrbS5v1dGM2WSG2wiMP0B0BxkF4EViCTd0E=;
	b=07K5P1lg+J9N6y2YAamLGxMtq0troPefOahriAImSdGU4yEa1dLWGbrqFbyNi6YM5pRPpw
	b9sLj4lWUjr0UNp909b6ot20g4Rn3ybpGc7l6NVsVF9+EcklZmRu0YBswlBHnVVozDMfry
	2km7nNCibkdzm/WmlL/xYLapDDUhFBw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhGOi3zb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788683296;
	b=h6ilgfThFhnVNRZmqb4NvWmZ1cbwTVLSBn0kjK4vvqmHkc66XtRkB3iJXpsrxasVllyMyy
	/MyD1YyHXm+j3RmNOz8BjAwBmkvBtKHApbSricTp9Niwzb8Txy3rlzNmJCycBaReOkNEbh
	bWb2refBGo0IKeF3BOLzW6YX5VeK0Ng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1522660142;
	Sun,  6 Sep 2026 08:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD8C1F00A3A;
	Sun,  6 Sep 2026 08:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788683295;
	bh=7TSAAf7dKrbS5v1dGM2WSG2wiMP0B0BxkF4EViCTd0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XhGOi3zbq//JHvO67UrobFFT80aGsjjauCD0+38TUdft3Ro1ayi2i6B9j/lN0J68W
	 t3FrOZYiO3gn5gW5PlygXwOACzLYFTVwAGLdIOS1AYA2C7ehdYO/NfoweezWEgmnvZ
	 EBWp6YqxzX/jyaBgRQKC0grYayIdgUD375o99CmCuwdTXEmQOEtWwm8pYKhndnd+Po
	 Oc2WG2vhpJu7keEcOhLGP7KL8uUx2DoZYy9fIE/HUxlTIwdaFyNTh2B+OfaKNaq9X6
	 CAxGFuKx0FiCXyKQnyc1CuryNGydWBF+4Tue6D/ShyJrYC+6DNqkSfPGTgNARjMQTO
	 bgWYf65LUGf5g==
Date: Sun, 6 Sep 2026 11:28:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Song Hu <husong@kylinos.cn>,
	linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH 2/2] selftests/mm: restore hidden hugetlb reservation
 scenarios
Message-ID: <ap0kF3dWU8UWaCpO@kernel.org>
References: <20260714021630.1063823-1-husong@kylinos.cn>
 <20260901173748.fb7a442941102894a0c42baa@linux-foundation.org>
 <apqBn7tWDHQeMrzB@kernel.org>
 <20260904104812.7ee79803a10ab355ad2cdf81@linux-foundation.org>
 <929d0143-91c5-4b47-8e38-30675b4ace5d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <929d0143-91c5-4b47-8e38-30675b4ace5d@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 35a4q5s1dwxe5tdwtdx7tq9xqt4exaqy
X-Rspamd-Queue-Id: 73503A0002
X-HE-Tag: 1788683296-353685
X-HE-Meta: U2FsdGVkX1807lsDQSzPuUuxBBNWCYpuZVC0bI8whQQvjUMHjfFRftTrLr8Cv49YrNSBKHKIwKOn58hZ4S1ySdyd+V//38oW+7Nvl3gHFBYgYa9wvLs7aDLOxIZCQGhW0Np3JvSOiFIpB4YloXNysHhSAYpaj8qL1+ltgUCvnhynM60Sx4oIAVSYmqG1axYHPQ+Rm0XQFycVHtxWv/eLtFl3GiA++7I2/PTMLOM4VW16/RGSMSlCXSiqdvovXz7JVxtO8tpsYxkEDQ9KUrqxh3xEXULElYKtGlw8688URwDCOD+D2PNxQ1y5sLvzrQpq+xIpiqPiHGNccI462A4g5Wh5PTU32qrjAtlv34bffVTum0BRIvqIRkdIRHzKyNcL9k3KIV1lOqghI1nkfKP2HgAjKl3WwHRWrwCTS9P9r2r/1EZp9HpETE7QjuRyjzTTGo840lLrybd6pmiL0k9QhZqL9gP7j81K750PVUGDFOQok6QVilIhjgj7mHe1M+vHHdH9oVvrqRS+i55BLIJTA3HKdrNnwOW0YOvNs2AwXj5/VqcPIl7AW/g4W8OzWmIivfBZYjudfzuZ1kQNxZ4PPpXWzQSwaiVz9iiLh0nDn6iAaIKjCpHk8dr41P4xg/0tTfTXbtkCoEUBdVpt0NGddleUiYhRabGbaWhQHLbDIp8jUWETYzvD7fwD2jZr60LebBBs+KjBRcPDa//IhGbvKYzIAHlsrLg45gQADBSSWPPTSLJ81jIxI5dcIYmB6nH2/yVlBkvhhKSv18va8yGOS5ZzRM5lpfDINhUcsxb9FFPgCz3IV9IjiNgX8/zS//Hl1kUN2204lifnS/xt8YJP7S27MJ/z3BFuMBPADjBUhKZZNY2ZHDAiZ1s2YavDrMoh3blCrrkG7z9QGPrCPqwsBg3Uw2/g1w37BRtPkz06K/Eq6YOMDpiutTKVSkyHR/4B9EFyZ662wK2XIWe6crs
 mxPjlrXY
 Gp2P7ftpBtFQFeaBFxU4dyXzzbuZDYa8QwQJ2d7DxHoD0hEyzb85atLPFzBZLOCdziMKZSmDW82blDNUOonOZV8UyPOWWnwAqnccQqBENDsY/ruHmnkkd3HQUjI2T2FIkYovt0abIEPBb4Y0Azo4Bvn25Vow3+fQ4SFBFXJ5lg61ywkfrNgb6q5tJiWVFRIUSFXkMbYNN6whNp7o+XlZQUgCm4SyZ2dWzEd1kIOlmA94xfPgg4cAQhpk4NnfKEQBMCO9zaCpfBpsB6RFx/ahXgJ8+2Zfcn7E8YzihGrNP7WS1kKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 10:17:12AM +0200, David Hildenbrand (Arm) wrote:
> On 9/4/26 19:48, Andrew Morton wrote:
> > On Fri, 4 Sep 2026 11:30:23 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> > 
> >> On Tue, Sep 01, 2026 at 05:37:48PM -0700, Andrew Morton wrote:
> >>>
> >>>
> >>> OK.
> >>>
> >>>
> >>> That's reasonable.  This code was added by Mina six years ago.  But
> >>> he's still around so let's bug him with a cc ;)
> >>
> >> And this code breaks our CI e.g:
> >>
> >> https://github.com/linux-mm/linux-mm/actions/runs/33040981840/job/98414290236
> > 
> > What do we need to do to view the error output there?
> 
> I recall that one has to be logged in in github in order to view the output:
> 
> @Mike once sending automated CI failure mails, would it be possible to include
> the full output?

I'll take a look.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

