Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0951C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C9B6B011A; Mon,  6 Jul 2026 05:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6A46B011C; Mon,  6 Jul 2026 05:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE4D6B011E; Mon,  6 Jul 2026 05:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9176B011A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:13:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFE82A0332
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:13:03 +0000 (UTC)
X-FDA: 84957787446.13.15F0EEF
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CB6B140009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:13:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JxxtGstz;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783329182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naoHFztrbYuFdXjk2Az0KSA/pBNbZzEdILKeRrHL4Ys=;
	b=AJcaQF15AUY8Wnhl5WCD1vq42BmhzfH1NafXA+2HcgGnpgsMrIdNGPbIDs55uhdFGlnBE1
	USE9lQwesz3y0ER5CZ3daqpaJM+a9ilDlatgbeyAfXf7Tsu8esGoyYpSWQnu6USv0EYz2F
	sVOrSt02YapLREo9FbTqc5/e4F87U20=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JxxtGstz;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783329182;
	b=ptzKAJqfDdlK8HPEdnY0qqrPdnPU2UGANBt8P1W7hfX6E6dnuhBs4gXfF4FbhEj4EYa53V
	kaSOP5dgvvzPoloKdG8+8lHewhlr52GFhza9kc8Vr2PbTTtXcleWYJLHiltfFtmoiBomat
	LyCZ3Z7reOQk+zFN4ierocWoW/N1aPo=
Date: Mon, 6 Jul 2026 17:12:48 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783329178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=naoHFztrbYuFdXjk2Az0KSA/pBNbZzEdILKeRrHL4Ys=;
	b=JxxtGstzVWYQajFrhm7zheyDPkIiaPm/VkikWt1KgDoeMnKBc7+G84Qkz4FAfc+4Anilac
	tki5u2P7T4VAN54VBuWXV3FT/LD+hC40551vu6c1Ox81KobLA0TeWRp2zmTdMx6dqqlyfX
	VpKWUerlDUCA6IHfv+nDnk4T/AYZg2k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, kasong@tencent.com,
	shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, chrisl@kernel.org, jp.kobryn@linux.dev,
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
	mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
	vbabka@kernel.org, youngjun.park@lge.com
Subject: Re: [PATCH v3 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <aktxkCILD63YMtv_@MiWiFi-R3L-srv>
References: <20260701235955.36126-1-baohua@kernel.org>
 <20260701235955.36126-2-baohua@kernel.org>
 <a9829fdd-75b3-4035-935a-f3a74fdc29bc@kernel.org>
 <CAGsJ_4xwfCoy3utvtAqAstKGD9ScH-n55bTTKrLiHj=c2doZFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xwfCoy3utvtAqAstKGD9ScH-n55bTTKrLiHj=c2doZFg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CB6B140009
X-Stat-Signature: yqpo3ypzybr3bbbz37knda31bdcjdm88
X-HE-Tag: 1783329181-989324
X-HE-Meta: U2FsdGVkX1/h0BJ/+LoX6jQ2yj76T2J5NYHmgnNc8WNCPK432lJ6bhBoUAcmsX5rhds7NO1QWDbN+wfXEzQGif9H8TmFFL6M3iGsEn7tBhB282y3Kt3BAB1lIZT/DvTWvBFuT73Gk7JvawnS9Hao3TbPmXcmymFr1WsBWrW0K7V43A6x6NpeId3TSEWhk7ZYLRZLr+nMX/M7FYyQsz4R6pI3l/evabLSicHL6gm0piV5WE4ilbenZI5xi4RgjuOH8x+8NZhmrh+Wfby9TjIORlscyQIIUKewLqUvLRfUaDc7KQ4VAG0QxYRdDyZcWdOEoRRDF7vTkfUqTptFo5GcbvusnP6UaXK6495XPPnS7KLu3o7OdwMsBFgQ0iMH6tG5XdO8KIb9LxIS2zR5rmDt2unr62cphNndjMlRqDhW8B3omh/VO3n7JlWNAnso2gFY40dMfWz22IV1tqX0JwK6Ez4fmrNezuxmhqqFLDhtY+Cmlh4cHOcjaZta2aTp/tZ916GG60zxC4Tk23Pgf53yY5VRz/vNa2m0DWqb7+AvsgbFLP2wQpdGMwbetR7f7TxxDQfwbcGNA5rdfOiMI7raa7fm1yUXIxZtRAFiK6o4aE3WTchmZ2vl2Xb2j6TvgEK9DkHjONpZWDbPhLHXSNoOJOKO5i19aLVqZnp4Tc3Hzu2Pw7k5JNL4b1QcOIcIRPQPkr2oCsmxu23UdtrJXg19TC+aLj426Roo8BhFwpCNQb6K8KfvStd7m2TrA72Zb459FnXtXPUF6s73tT/rJdYauOLKimHBQ2hBv7HluZaKqkZebCy1rnGylPHzL9tguAE17OnrOjNXt5t+2R16kzvF+aAbEKtce7NSokC5UzU6xVAaBH+zUutmlatyF07zE/tW9bs60IwhccSDHODh3fO0+i98BmwZUyuXwLwCBiokIE1U9TTpMxo4uhnRsz1r/GGSn62bfG2JABkrJDZJy8M
 XeFY1IYn
 7D8zpqNIkPxdnh5JyOWquUqK4ZwY3w+HaO2nYiPMCCf23kbmphXJq25G8hynONQRrmyToJHq/K69ZWpxTENytSsfkwredZL+oUqG01xLPooDwGYNhOUte3juAqvPLpWHwbvm9+vYbteVtwh5+6b9/cWUPg3vu68p/5LOJT+8bNOKEVaJoQjG3rFucgbUYdoT42G0tkwqjnH1EP9aZ4tQuLvavk6pDqFLeNxM2Vb/IvFG1JzAGM9XxKncwTKK/wwKDfp2OWfDHelKUGbLd6D1Vw8t8VvS+rXhUZrX31cPs/bsEm5KvSRB5dp/3uQupNKUn8Lk69PzzMy43FfTsYITqYRs0frnCyC4genkP5Po9NuueRq6gzqGuVHdNtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On 07/06/26 at 04:18pm, Barry Song wrote:
> On Thu, Jul 2, 2026 at 4:05 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
> >
> > On 7/2/26 01:59, Barry Song (Xiaomi) wrote:
> > > There is a case where `folio_ref_count(folio) == 3` and
> > > `!folio_test_swapcache(folio)`. In that case, both
> > > `folio_ref_count(folio) > 3` and
> > > `folio_ref_count(folio) > 1 + folio_test_swapcache(folio)` evaluate
> > > false, causing an unnecessary local LRU drain.
> > >
> > > During an Ubuntu boot, I observed over 5,000 redundant local LRU
> > > drains. For a kernel build with a minimal configuration, I observed
> > > more than 20,000 redundant drains.
> > >
> > > Fix this by checking against: `1 + in_swapcache + in_lrucache`
> > > instead of hardcoding `folio_ref_count(folio) > 3`.
> > >
> > > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Reviewed-by: Kairui Song <kasong@tencent.com>
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > The other folks should probably re-review this patch that changed quite a bit :)
> >
> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Thanks!
> 
> Hi Baoquan, Shakeel, and Kairui,
> 
> Would you like to re-review the patches so I can re-collect your
> tags? If not, are you okay with me removing your tags when I
> send v4?

Is there change you need to do in a new version? If yes, please remove
my tags, I will review v4. Oterwise, I will check this v3. Thanks.

AFAIK, usually, if patch is updated in a new version, any reviewing tags
from the old version should be dropped unless the change is minor or
trivial.

Thanks
Baoquan

> 
> The concept hasn't changed since v2, but the code readability has
> improved quite a bit based on David's suggestions.
> 
> Best Regards
> Barry

