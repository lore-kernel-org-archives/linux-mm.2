Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4266CC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1257D6B008A; Fri, 10 Jul 2026 20:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6B16B008C; Fri, 10 Jul 2026 20:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07B66B0092; Fri, 10 Jul 2026 20:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA6016B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:45:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6785E9029C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:45:05 +0000 (UTC)
X-FDA: 84974651370.09.204B979
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7664B10000B
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:45:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTpii3ZT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of djbw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djbw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783730703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIlT+GTV4WhhrNy4N/2keFT3wGvoTbsHteN+Z3WZskc=;
	b=IPXDP7Q1K5rjPsJ0av8wJZRUFBtoo8nbIZdQhx+ldGSsHJXKeiUs/qmLAIXkjTbS8YavpQ
	90eKyx+ZmaDQh9d7ofN2Ew9oKstGoFWqctaSbd5u6CTiT1QfLZfMeUKHMcI1NLOpAXW39/
	aXSVynOhayqZEYJKgDoHkYbAw2gHj+s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTpii3ZT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of djbw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djbw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783730703;
	b=p2BBw5aQe3Rd24DGWQyaLTtQevzhDwnhxfVBQH3lEIUseKfQQ+gjqwsA3h1/0bCXbtEuLH
	t333mVqjkr1U4VrC/JAmYjxioexbu3xHaJoiK/gjmdJJB9DBSg9E25jo8S0dvjzp/ubGEY
	XCfmzEOSxDuhEVd+C3gpKVj5ViD8P1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE13B60EEF;
	Sat, 11 Jul 2026 00:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A141F00A3D;
	Sat, 11 Jul 2026 00:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783730702;
	bh=KIlT+GTV4WhhrNy4N/2keFT3wGvoTbsHteN+Z3WZskc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=UTpii3ZTDjIqVdqCN3Y7JfG8857lWe/8ShEDy/EdfU3y/XMnyR+G1cxIkOL4O+39U
	 DhJyWR41oHjppG+ui0PPQ4f06lLHkzHP5JETmOobXocWuKLRdZ4XRZ2qM01xe6gGFs
	 TUOBaN/2ZcbgNJ7OdTpd0LDccKTM0pD+uMugDiJmAe5wcEll+CVo8U4xyouB4gbKXR
	 LJGPccgGwIoMJGU0hcB8CCrfZ/9m3pF5ef46DuTkdn57vH6bhuljSDDgkXng5mlRaX
	 cqnDsFAKwQajYYT3g8dp1yzEmqxojWvcOBpnPKAKnfVnZVBkblRry+ZIqYqzfiM3al
	 OyKh72u6/dtUA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C3820F40213;
	Fri, 10 Jul 2026 20:45:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 10 Jul 2026 20:45:00 -0400
X-ME-Sender: <xms:DJJRahdIAQytT5U6Nr9NADrFKI5X32Ef6eIeXrnSsVS-uAfPEHNo5g>
    <xme:DJJRaoZlNfqciEJoJGQHyC_74CCjXfgmfHMQpSVehkbOSM9vXB3PzU1_ELaXWb8sN
    GK26JE0CYKmXxGmjRMt60VU5-M3aMuPIaMO-HagBlwHpJ6hsCEJkQ>
X-ME-Received: <xmr:DJJRakp_KEuh8p92LpbvK9AG7ALSylMrpwmSY3OqkrCToAG4Er5h-j40BPWEdh-OqqigdjJDXJifaCilJGOAeezcPxJiGZR5B9E>
X-ME-Proxy-Cause: dmFkZTF2lv/BTmJtmx58UCBnX4LYuS/hSPolWJtMhIC6n0miZhX4RDMWuAT1Cl4GARjHte
    lqEr6OARdwjx3wovv+JqFFm48+pvz4Zx4EQgeWrHiwpat62fKOUYIDPSrStJXAVJdwqAxx
    1VEqZJrIf0stTWrfvXtzf0i7jWSJNy8uf/jMXDtx7Ywygxat1p6MeXmPc0lsZiFUkLa3sn
    qa6w0Xk6djDcgTGYwGlBlj0VErXEEYhYZKCiUyzXOxRQ/T3BtU3+nzlNyVrmTVdMzrm/96
    wcvb3aTmxG5/VfGOD77r/GAytqa5b3EPaQD9Vf4C29SbV+quV+TOBZUtmCKPnndUNJDSRZ
    +ToTW+SzNgQPekcbdtuVHSCZJfTWEvui+ohy6FWXQGTH1WxWfOkyT5SfiV0QmnNv9YTVyW
    Az3C/jQXQ4aeolLcpVA+KSPE8sQ/+V81F48UYQyA6+hB3F5Tcft4haEs5wdocS7yCVLRmM
    eSiI1bmkYAGgHgFPZbPfSjjX7xTDURKGauaHAqJAUKmeWcQOaIbRLhfpOBpXDtRQUr4SiG
    51D5Yz83d+midz8y+A0C1ngj1l5eqsImNnder4kQrBTBEBTa0W2jRC0Bk7wTpgyAL8NADc
    UEb/7ghPKpmuk6TFsfN4MhANBLmxJZlqzMh+KiUGp/hqzMkKRBDuput0FGOQ
X-ME-Proxy: <xmx:DJJRar0B9iN8wAOFCHuPaFQbJb8V8saeOyXydt1pXldNWq5erw9Yaw>
    <xmx:DJJRapp1RbqjinFk8me3sngyUaRw2_y5e6QtzTp_k_cSm22LLuphaA>
    <xmx:DJJRalTyfinINTP6H7IfX-AARPsLe8FiwAF8iHR8kaKh6oW9h24D0g>
    <xmx:DJJRapoNmiKSZjaNy8ogBdajJy32RFp9tqhPPoJ7V2wugW-DP9cCoQ>
    <xmx:DJJRarwG0Kc32_-9CRKv0pWv_Eu4zCEifedKZPHpwBNqYnreLAv8agHk>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Jul 2026 20:44:59 -0400 (EDT)
Date: Fri, 10 Jul 2026 17:44:58 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com, 
 david@kernel.org, 
 osalvador@suse.de, 
 gregkh@linuxfoundation.org, 
 rafael@kernel.org, 
 dakr@kernel.org, 
 vishal.l.verma@intel.com, 
 dave.jiang@intel.com, 
 alison.schofield@intel.com, 
 akpm@linux-foundation.org, 
 ljs@kernel.org, 
 liam@infradead.org, 
 vbabka@kernel.org, 
 rppt@kernel.org, 
 surenb@google.com, 
 mhocko@suse.com, 
 shuah@kernel.org, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com
Message-ID: <6a51920acece6_35cf3310061@djbw-dev.notmuch>
In-Reply-To: <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
 <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
 <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7664B10000B
X-Stat-Signature: ctdieyphmdwwf9pskf6xhip5sshcwf3n
X-HE-Tag: 1783730703-819559
X-HE-Meta: U2FsdGVkX18VYcqbwWKssv5Xaj7/BmlWQpKLpjwjOJODyevrj1vH2No4rCzYyU09y9A4JCp1wmHVBkQFq15jk6BZngvq7Wb3KgR+YhzDDDKX4dcjqQBNpa41xzXLb7sEbLzv0OGT1IBWD7aLrpM+Kd2TT6Wum1AGUrICHfV24qRSRzJUyphYfGG133gIXudvk0sR4oSfKu26RZ9SOUWRE/GUJa7QrTX7YruoZaEOTdZK3nFqXSORPAjkm6aoZGbCPonewsZgOt/xE7SQk4YEITdoSMxXA9olU9xrS8xltuEuBbEb+oLseMnC1FRypjDx4uIU70SPRtJm4WOOLNSazMhv+qKu2ttYPKgcVDkw8DheXARgQ1oYQIvWYu95/fM1RBY3Hn2kj1LYiIr6QGQUVXKsOqaxNoHji9AYaLIWmHZtp6FSPEa5w+RQv5P2weroKePpIaTRMfdrqtwcaQvLPXJdw6MzqpAcTN+G30Hjoy82EUda2ykRkXES6GMo8LU1OFvwBbD/6z3GlwJRkt7DAlTQkM15Y9iQ/R/Fv7PkBCrha/CccStj/Mrr53oYmEWKieXMAJsTqkCA+c0MbTFNUuzefdw9ciTAfoxMuSPs/YfTsXH6F4biB5CG24AWVGEMI72iTUHAklrOHbv86pNqs1wYrMnzTTDYFmj7ZBQfrx+aFy9ayj02ud/GlNaTWxKlBBysTAHtM7FJw9SNhA0zAnTuHR++1NrY1ntcIUTpANBt1R0P0gVKe2kvUdaJPxT0qg8ToJnrGyrb5PCiQpBy1vJzFAhIg5H0ijWgKER7JDrtIJJrtH9SbwZ6ZigttbIA7MY/8hzIOgAGRkRF3oeA7H1TsPMjBsWtEeZq83g9+jImnJ6dHKRvalYXl92CVB6GvR/pcVpzgNek9x85PSRR+GJkMtkzDX4yYEbrGhJQTXwwTbo5Wj3k71hHUH6yovwarcAFJcv19UG2uOjHzjo
 HTODXjtC
 Yf5ng37WJfoedx0NsStRRu686b+48G/v5/vx3IC071DDBKZEei8cHFruanpfY+TY5jDFlyoX/wOxicE2CQpWXuhgYcZ9GrqF6NoV1lY5JA+jeRMTdPwFDrwPqtkRV/yL8uNEbEwgQR/AYrdcf4gOjtJm7AahdPevNge8U8GYb7QUgmscen5uDZy62DcYuSvqymIUW44wrst+nJokVsnLip4UcYewyFin/cI1MAVG3BLHQNeLf6AlTNXGHOS2Kfe3LvY9au4CUPVmZfT2VYVYhqmJY6kV2eD2FXa9vg41QXd9qI+7iFGADF19DCuMybO09mzaFBPGjz/A4eflyQf/WparPvsIfwH10hw94D5yhEqDPXTPCqxGKhFX5/qXNNnBpsw/+2VsEtTzgg0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price wrote:
> On Thu, Jul 09, 2026 at 06:08:45PM -0400, Gregory Price wrote:
> > On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> > 
> > This was more a matter of having the DEFAULT set consistently across
> > the dax driver variant probe() functions to make the behavior explicit.
> > I didn't want an un-set value bug to creep in here somehow.
> > 
> > Happy to drop them if you think that's unneeded.
> > 
> 
> Ah
> 
> Not setting the value in each of those places is equivalent to setting
> MMOP_OFFLINE (0), so better to just set DEFAULT regardless.
> 
> So unless you have strong feelings i will keep them as-is.

Right, the mild feelings are only coming from the changelog mismatch
which says "Oh no, device-dax drivers can not specify their online type
besides the default" and all this series does is keep the status quo.

That can be had by just having unconditional:

     online_type = mhp_get_default_online_type();

...in dev_dax_kmem_probe() and get rid of dev_dax->online_type until the
first user arrives. If you are respinning the series and that patch
drops, yay. If not, oh well.

