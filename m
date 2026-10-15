Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F310BCC6B3D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2336B008A; Thu, 15 Oct 2026 10:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72F86B008C; Thu, 15 Oct 2026 10:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62C96B0095; Thu, 15 Oct 2026 10:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4B6D6B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:21:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40D88A0A60
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:21:16 +0000 (UTC)
X-FDA: 85325072952.05.2A32183
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9DB5C2000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:21:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X9GoNncv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792074074;
	b=M0X/xH1le09IzrROpIdLhOXaQCmu+IY8epCFgu3ERGI9EjWeSNTHPWQf/dKuKQUGEW12WQ
	xa2e69hzkwLySKvGKBZ1ZLiGceJiq/tZC1tvk6St4XQvoNMhtsVDe8AJ91ohhpnizwX93F
	ZM5OKOAGk8gUkjMNx0nZJTWEFBZp4l0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X9GoNncv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792074074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPbwiAj/U5jx6Paywkr8oSvS8UbuCkW4wBewY//2I4w=;
	b=QJaDqVywyYTfvg3161rVqNJCmsxihk5km4VMgRTkRu4jfSTEjxMySmrytE9jsX2pDEYSVl
	shazDs/hSCO/p8AUia+WKblOpQnJ0l1EGqYAQMy7W0yDlt6DqFv4gE6p9Us1UygEdyM5BW
	eZFxLaIGTlCeK+uzwHTlqxhLGNN8lpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B2F3601EF;
	Thu, 15 Oct 2026 14:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0081F000C5;
	Thu, 15 Oct 2026 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792074073;
	bh=XPbwiAj/U5jx6Paywkr8oSvS8UbuCkW4wBewY//2I4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9GoNncvd9RH3tnjSeWzXZ+qQNiclD7IapaOh/bPNX9c9/FmzNLZ3A6SBNmUHmhRY
	 6WzWEtKlpG66ObUQ7LIBRD5Z0gw0K01KRuDrD5CAZ2JfKslJHemc2p/0MLhTrjefT6
	 nBJpyMvPoGaMh9ZOr89p9+KwxsczCc+Oc70D35Yl0Zrag7JuTn17SwtLEb7L0sDzYI
	 2xovEwpGard1NaJTD029REt4Nc5NVXpy9ZpjhjuhhGTPpSZsRVVPTTpCWPaEWvhc+z
	 F6VEHjbUf72KosxM63gY0mTiCwSgnARCT82IHiIxRh4KVZQyPmOeU4r2IE3s4HCGKK
	 g0WGV/Nt82+Iw==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm/damon/core: Use only installed probe in damon_merge_two_regions()
Date: Thu, 15 Oct 2026 07:21:06 -0700
Message-ID: <20261015142106.102721-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015135801.19326-1-suhaas@s-joshi.in>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ub7wk7zdf5jpas9c4obit46xbt7cr6wk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DB5C2000C
X-HE-Tag: 1792074074-690125
X-HE-Meta: U2FsdGVkX18n377OeT5klgsOhg4wliodTFfbownALHgBBDBZDSBpEIZAP674EMUti7Y82/aNyRTSEgJVknMEZSleAfZZxjJOrbZal2tVGdMRqQapgVjKma+7PCy5goabl4w5umPfeLoLsCVyMKYXSZSomSlfjPyF2qim3bxQxs81P11tL9fPMNDYqyCS0oR3tdxPq/WqApR50usYYqzALnyCvUyd4ywO2mXxqd2N85sGTxQ0NwUdy5o7+u3KOcuBAQzoJYyNDmjUuuefEGtNsnEp0RA5sr8elwNseHyHXbFLmuU4rilQ3A3QEZd8sGSQwaadq0YklaN1atTl6ezRy1/xvQcQv5dyCwyKsd8+NidhzAJaXGDq01LnTHSaHP8Y5QFS/CoLXbrBgj5DXKJyYW8D4A54n8cS3tIQJ9REqx6pO16e9MjLuBKDJKVP7KCFf5ImTsP3jtLzyJOffS22pjtPu/sPzRaI241f53+kr9/B2k1eo6QnKDRhwr+ma8iLFEP09m9PiW6VY2bYkgIhjKa0PE1iV5oxhYiaBt0x7BmFK8YFbeJQvpoODbvLRlfjo5dh80SdLxrz/duk1O2+JLRvZiVXbB3l2BtPOglTS9qP3jys7bLJbiJeQlJjg9gDRbkXy/r3YrI2cShQDiIO2F9chwf0yfA3i1LyVClQMG/ddgwOrOuYiodTCdrbgZ6npDiEo5jIOYViMgIU/4WtL2URg2EH1Hj4F7vTo017kz+qT5PAfzJSqVMl3ph8baWZ0ssAeEKY3yYKzHFfU35ZBopwBMpe/zU7m9hERiXUi8rnH7a/806gKUGf/gH5iuh35QAx2j30SPKu32qBre1IBORk+bGOsERZCCKKyRO4Ui0uOmcfGncxsXBwby77F5UGosRG4t4ExD1gz2pOYhlWVZwky1jrJ5vhk0tNL4DpBzGvWSUcCWQUPoCgt14MWHs5ITmnmLhiByZCSWPlMF3
 U2kX0tGO
 tGsXSKWgspygHuoNk6fQBUQk+ghmf9MfE0BAxY1iNJlwbaXKnzFUebgZld9zmrDwwUqWRseTtf53sytmkPPtvfjXkRICY05QO5byXUZjJrT2wqwW45Rz7Jk//OwR5uhrAxooAFiJtJkUX4+mNImC7Z0Ne4+hLHEtdL8l2pRQ51wi+Ze32mWaGMH4gKD0f+DZIPNPMD76pTraya+1WHhQwp08mTNofGiy1XKiC/uYaK2Sx6465JAUtwBLsiZRtYLfBj50WSDiD2R10mq+uQXRAQUJrnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 19:27:53 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> While merging 2 regions, we iterate over the entire probe_hits[] array,
> whose size is determined by the DAMON_MAX_PROBES macro. However, it is
> possible that we have fewer probes installed than DAMON_MAX_PROBES. In such
> cases, we end up making redundant iterations. Therefore, to remedy this,
> iterate over the list of installed probes instead of iterating over the
> entire array. For doing this, start accepting a struct damon_ctx in
> damon_merge_two_regions(), and update calling functions to pass this
> argument.
> 
> Update the damon_test_merge_two() test to use this new signature for
> damon_merge_two_regions() as well.

Looks good to me.  Thank you for this patch!

> 
> Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

