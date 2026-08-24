Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6E8C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759526B008C; Mon, 24 Aug 2026 03:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A9C6B0092; Mon, 24 Aug 2026 03:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F426B0095; Mon, 24 Aug 2026 03:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45AC36B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:59:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8997A32A9
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:17 +0000 (UTC)
X-FDA: 85135412754.01.022D0AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 37F881C0004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kmA9km/V";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787558356;
	b=7HzA1Px1gnkrilUwIiSoi8Y4S/IMBThhtNjfsCzvbipLo0iYVvDZl0hFsN5VnrzqrlanM2
	nQvtkZuiiWE+nbBan11Wv0eSWLhS0s4t1A7LSssf45FpTb/mwScHSCUHn7fhUaxCMkbkHr
	dzWFN0cr0FrQ8TDwEKsWll0tFxVJUsE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kmA9km/V";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787558356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlCrxymSsXh+tyzlFmElD0tkq0tcVy6WfjHyPiQmTo4=;
	b=uQGdMnDWwC2QuWexMA6T9RWaXh2pUlpIjibzcsEBwz1t/TeS2dHwh5u0b14E5W1KIwZVAK
	OdqGOqVWrZvKFFEpbnE/H/b4H+2oiYmky47/S5laqZQL7tzMrtLcJQ+/vXLpr+vA9BvPfR
	gguQqMdnFStlveXO08C2vDwZqyUsxHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13EBC40A51;
	Mon, 24 Aug 2026 07:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C661F000E9;
	Mon, 24 Aug 2026 07:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787558355;
	bh=jlCrxymSsXh+tyzlFmElD0tkq0tcVy6WfjHyPiQmTo4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=kmA9km/VBI+guT1+n6nq+sV0kYYpGsW38wJpCGOE0xoyuTzbdifAn63TJBt2nr82u
	 jjJWb3PqtkloIwVH5rPrUt41EokVtWB+gSKog/ZV9mtq0UCqllleAW9+eJle1kPVyN
	 0OaOEhllsLOGr8ykfppFUezdigisBGi0EeIXfV8hOQIflmpTm07SDP1rqK5FMC5eMJ
	 /RqrO9ZZO0FFYAXT/bd+mFUyveay4xdukMai0Q6wd8WXbFmo60aCT132D+Yam+icoE
	 zI7eiRzfqnKfuKuO0OUGPY6V1fOdlzRB6B/ubfQt0hAg3YNbQFmu8HJg02QrXQYBde
	 N9ON59Rq8YStg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 1/6] selftests/mm: make file helpers return errors
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260813181230.483746-2-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-2-sarthak.sharma@arm.com>
Date: Mon, 24 Aug 2026 10:59:05 +0300
Message-Id: <178755834509.3606540.837800416127261846.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37F881C0004
X-Stat-Signature: deyucaapw3uyk5hb9gjhd16ir3kac3it
X-HE-Tag: 1787558356-106420
X-HE-Meta: U2FsdGVkX18aO0XUOiNkj9aQ1HA2Whwxg5phmd5yH8dLk9W+Xg0eRq7SQemofCWIs5T49AimPuK9S7lyjJVnvT/wA+VXm2Q1roGAYpPpnYr71lfCauuWC3IzBFarUXsZSnNc2PuyJna7/eSOA/dFHzkKVv/g/smzAVHlLzn4nqx7Yt5o34At8oGwMS5oEzkDltLnMi3kbtAXJL8rKh5eKsHDEPwB+So8wAA+S429RKAVIOuq+EQpJ50kR/XxZTHqj/eLeM7FTG66ZvUS+tclHelPrS1VGuXHQbG1Efj6bTxQoAltzUZ84jijguurEesxqg1Ca7z0pjYBjUHwV/s3K2veTorX9lXwwKIUhwIv8fcZP5XFB/Vraq7kOg1eZhDstikziU5tYZNnk0hD6glBteq10WSNskRPhQmVb4nf+WIRIltBVDLONO/YT4uUsP8tq4TzQKVF/Mf3E60XRXo5Jcfyhrag/ZLSsmJ4fsmWIv9xhd6ZTiti/CzWtXWOS/LAnxW3HS7yCqnRKSs7NC1Kj1jciefV2CRFbGrRGjdNgNuRZ47gLaZsUGB2FaexOym4XtH3fU/8VgZQj+oVFMbUjfhtIiUPll+Mc4zlb5FSoRoVs4kLXBOoD+2fweL8sWg7+Lx6p+oDDZIClJlNGRVXGssBTeAYMY4okxh97G51Z/wan1iw3TNzdXyNx//qwgfTGN/j3HJVur5W+alPRjdTUpmTs2AqOPARHHjPu/p1g9S6f02TOWbJgJvV0PTYsWUdPNiXu+mEC82y2AIGodgIieDdMCPoDnfGKLj/XkN+YsnnrLYhjJ2Q6pDbYdZokvUKTia1qIEczr6G10N5gSnkNoyxa7CZTPnmoMGl673kDicZm1azfP6loNq/rWtJRc7BBK7rrPbMVNVBz+6DCrMJ05Il3K0Zcb37NrnqtzM8GVhiwrNfSgFCHfvbUa4YGzKN2FWBJYESHi56b2H9cWq
 q3+d29QA
 4vfVuuKWbl5wzFCc/i3ChEH8a8mt30nCC1dMCfXqD9pFnGooiwsDLq6SxiGQfUFvG1H399vuee9c1JkQT08qU0gF3FQAd34Q3cecghqHgv6hbk6fBTIicyuVMr32kSqjtpYnAIiRdaNWR0PHuQ+m49mGZMwr7/AHRDtSitAhcy82aG1meXRxx85j3Y0yYyliR4vNQtjQy/6GDlQAE6Edaubs5t4qZenazVHxMuzEafa1KKznAMLxzvGKC1x1h5E5FKEVz+39QWSvGjignR47mA9PiBnugAzFFk8AeZY7K5Q9eY3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 23:42:25 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> Change read_file(), write_file(), read_num(), write_num() and
> write_num_ignore_einval() in vm_util.c to report failures to callers
> instead of exiting from the helper.
> 
> Make read_file() return a negative errno on failure and 0 on success, so
> callers can distinguish a successful read from an I/O error. Also make
> read_num() reject negative and malformed values.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


