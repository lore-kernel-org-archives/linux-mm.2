Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C35BC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC816B009A; Tue, 29 Jul 2025 05:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6676B009B; Tue, 29 Jul 2025 05:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A955E6B009C; Tue, 29 Jul 2025 05:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 978A26B009A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:19:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35C4B59611
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:19:19 +0000 (UTC)
X-FDA: 83716753638.08.4F977C7
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6160B140002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:19:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Bkvd35MX;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753780757; a=rsa-sha256;
	cv=none;
	b=LwKBJrn6T20xzXawUU0WxZ3VY55rAnYg9+BeWnpoYfgKC+bTDbA/szBhwRcXtkiXcJQVMD
	9Nr/L5GcL9bKRhZMsfeki0lB+IbGwXGmKSc8Vz2YOEzn/GMAtjBvQNXv7aVVn9QATi88wt
	bw5e4PCT3YKMn/IEkDkxRmzFWkpAo3I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Bkvd35MX;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753780757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FrFwM1VTnba/UhHasFMl0CnHRVF7mL2ndb/lv3touvg=;
	b=XsG5l8Hl7wc6/RIjUmWKRLIes6VJs8N3YaCdp/s9GMJKLFO+1TSdz1ViPoZoUTvcqLQ3oR
	IY3ejZYJDhLRdaCgVKM9uZ4tL9XVd9EH8PNc5HquAwp5HhUUM3EjCGiOtKs7R+8ySxz9ID
	2/s5vVikalNZN4WItJNUTJf1+lQ4C2o=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-adfb562266cso804752066b.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753780756; x=1754385556; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FrFwM1VTnba/UhHasFMl0CnHRVF7mL2ndb/lv3touvg=;
        b=Bkvd35MX0o820PYiWYFQPikfK+crCOXYvCsgcabRmKLwDHlYHnsMNTbnqgWzIOs4U6
         kgIQ6RHTZNRYfbqxc5Zkp3RP3Vvv+3gmg21MbUtf+NlYUHE3XIyeaAdEwo5zoW6Y+gvc
         KsAyNc1QU0SEbSj775mBZPvEXnaAFSvSkLcXY/pZtA8iGc+REqiCy6yExdyPjQvUjicO
         DjDC/lByWwljX9Eh/5ZF2fdqXICGUOliz80VS0LzTZt1NLeJeE1GmxhYYDgS56bRJyCl
         2U1wDTAYMPi0HqGWyrr5+915yGJj0Vl4YW1YIDmICSleAb6YK1Q/TDIfzHUPN6QuDlaW
         7Ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780756; x=1754385556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FrFwM1VTnba/UhHasFMl0CnHRVF7mL2ndb/lv3touvg=;
        b=ncQRZsPPCtKZAYyhOqzHCV9/LnhqS/afOqTdwc4LAAxFY6D1sZCFDbPChfYmSyZYpm
         eSwYGt7xmMNUCQWB/sKT881Hcrguj1aKWq30DPIc0kkwa+JFHaGORYOVUm3rgnf9KqYk
         pRUUXmFCb7T4+d/ATNjIS4WIafS/olx+mRIKzU6924s3Y6Oqu9BEHgLIWJm+fQpLkb9M
         rLENG9GyBsn0M3MORte4va7ntt0nJGs4TwzBpJacBjfxynMhiGFUtWXBqoJmniTSXVnE
         m2PkAPDnzrY/QFV1ft8XJo2fnyc+kz/9D+2OzzIlv6hFR8Hxmo17ocF+R1ET1n+yv97X
         lkTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAder1M6NYrXPItxaNCKmzHfXUpZY1S+Y47abPs5VXw67DA7dd848ioHH6m8w/caFqbOVLNq5BOQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1Oim+omOlY/rFrckoUl34HamQ0EWp8dBLRHmP47jcXdXY5ZwV
	FitwfQUfx8pO7xu4zzz5hfHNgidC7B0Qmxle7SPUielXjMFQEqKJYv1KOCtS82r/H34=
X-Gm-Gg: ASbGnctOEF8PJnZzGgEdo5SDvn98GkueCfZl8/9E0D84Q66BC/cmZFzAaL7fSYub/S9
	Y/7qi9kKApEdEM6NlITSyy6g8Z+sjPIEYtLMkxpUCjxdaepBXAUGYF6fO16uqjYRQr95gbozbPR
	GW1BQyAQ5vIZZCmWitz2pEnvKpKEkMSOgONDpP4bH7W1GqjRPc2Fe4ZOR0t2tcBrGPXhFRn8eA8
	SQcYqZJJJSr+nVHgN97WQ5RmIJq52sjUM2qP7jFKnwKajoLEmbYvAQPPwpCWaqgwlm3FqitnWIJ
	4ChKrgUxu+s1JVloO927932O/+CrGaAQatvlVJOwZyHBXyNCcCm1Y9xjO/aRXZWmNerNu+LeW8U
	y9RxgjpWQ+IfeVNBFtbja5g/5PA99xiu7FuI=
X-Google-Smtp-Source: AGHT+IG5if8x6TzCm9A2O62HvaAVkznS6JFPkv75AtILJqhhNjqt74fPiYQzDCocAuv9abxq43Ts5A==
X-Received: by 2002:a17:907:3f16:b0:ae0:da2d:44b9 with SMTP id a640c23a62f3a-af61c4b19c1mr1854043966b.7.1753780755612;
        Tue, 29 Jul 2025 02:19:15 -0700 (PDT)
Received: from localhost (109-81-20-172.rct.o2.cz. [109.81.20.172])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-af635af9967sm545754666b.131.2025.07.29.02.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 02:19:15 -0700 (PDT)
Date: Tue, 29 Jul 2025 11:19:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hannes Reinecke <hare@suse.de>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aIiSEpQhWqPsvaST@tiehlicka>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de>
 <aId16W4EaqjANtKR@tiehlicka>
 <3e88642f-3914-42b0-b864-4ad374b659b5@redhat.com>
 <ac7add36-808d-4883-a09e-ef1bf6fd6834@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac7add36-808d-4883-a09e-ef1bf6fd6834@suse.de>
X-Rspamd-Queue-Id: 6160B140002
X-Stat-Signature: bre4kfmwi7ogyp6dzff43jq5hwx3c8gj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753780757-71929
X-HE-Meta: U2FsdGVkX1++EtqM0Qp4yyKoVj5r/C7fix60d8JLzl8Fjwc223GQ4ghRyJq+n4IoXCWsm9VaJcyrukCj0GYg26rbeUlfAIzR/eJIuZa4IkqdIoyN+QBzR2LuNKzhOHAOYWJknHqadRLkfnOVkXtt7+1Lb5xqViD2teknDdWDmjWygndOxvk7IH8ooREMRPQdcKh8fg2BJs1YqZKGUXuK7uYReokThuInfEoQOHtG9pbrQCMcf4nmBPV650W+wINge5VrM8rSMdfgI4WmCfTW3JkxiWyHf1xnDHK7A0JvDSL0dZ6jzCDZcOCCTm4Rj9eM5Gam5Q3KeAhF8hU9zkD8v5mM5F8kdwPzghb0po9g+rbG50JgGsUdxL/a8NH6QDcSaSVLeCSz9v3SMCJiGc6aOB7rN8K9I4L12K7Eq51SjbCXIbMItSejMM1a0PREyx0LmJmhGeHXKRDTdV+9RK6z9W0rBsT+QhgVUipr8adZ0MbiIvBbeoUj7rRkMr22Pb9+fp3+7/4Yw2wBH+J68P4kMKRuTrovTSCFK7I90//FH/ILtpNepEb6RtXsdhHDPLO4YDB1XEmTYZxJAyWZVWHTulzZ/5KUT4VFFk0N7kOI0LEf7y7GQBFJOATecc5+VnK9z/GFmyfuS0b4Mm04UcvxJBIow7s9uzHu+VfhZxjk+o6NOFi1nuHRkVXgOBb2nGRxdVC5A4Kz4F10J3YbYHHLzmHBGN6s/hhKX2cqUpNWnf7Kx4k0KhKMtOVAeg051j+eCWJillpwf1KkEu2nuIDqD5tqfjocSoxH8dHfIkd2yQdywRAkkScyvza0VUanYxExapHjCneH9ieHK+6Iu2NA225SNjluOxMUV0RFhOP8p2ywLBsksk+c2YdkN6X83PYl9BgLt5iH9upFz74tqnYajWQq0OLVL9yEkL1o0VifhlLonj6YKRz01vmskBmcDcM2b9OQ65fS2nOwpUIHvor
 mabb75Cc
 uLl/SZfNNTJNDAZFCWwQoAk+hXxkjUrfL/hMN226Tl0NEk6mIwz80v8YxbsfR9hDotgLu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 29-07-25 09:24:37, Hannes Reinecke wrote:
> On 7/28/25 15:08, David Hildenbrand wrote:
> > On 28.07.25 15:06, Michal Hocko wrote:
> > > On Mon 28-07-25 11:37:46, Hannes Reinecke wrote:
> > > > On 7/28/25 11:10, David Hildenbrand wrote:
> > > > And to make matters worse, we have two competing user-space programs:
> > > > - udev
> > > > - daxctl
> > > > neither of which is (or can be made) aware of each other.
> > > > This leads to races and/or inconsistencies.
> > > 
> > > Would it help if generic udev memory hotplug rule exclude anything that
> > > is dax backed? Is there a way to check for that? Sorry if this is a
> > > stupid question.
> > Parsing /proc/iomem, it's indicated as "System RAM (kmem)".
> > 
> I would rather do it the other way round, and make daxctl aware of
> udev. In the end, even 'daxctl' uses the sysfs interface to online
> memory, which really is the territory of udev and can easily be
> done via udev rules (for static configuration).

udev doesn't really have any context what user space wants to do with
the memory and therefore how to online it. Therefore we have (arguably)
ugly hacks like auto onlining and movable_ration etc. daxctl can take
information from the admin directly and therfore it can do what is
needed without further hacks.

> Note, we do a similar thing on s/390; the configuration tool there
> just spits out udev rules.

Those were easy times when you just need to online memory without any
more requirements where it should land.
-- 
Michal Hocko
SUSE Labs

