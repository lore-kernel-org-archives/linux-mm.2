Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5D9CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053FA8E00E1; Tue, 14 Oct 2025 07:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0084C8E000D; Tue, 14 Oct 2025 07:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E359F8E00E1; Tue, 14 Oct 2025 07:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF19C8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:04:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73E125B9A9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:04:55 +0000 (UTC)
X-FDA: 83996437350.09.06805D6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13A354000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:04:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ICFBk2in;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760439893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Mvh4ql8Y8BBLDK18emWlEI/npE8s1LEzxvuBeQPUok=;
	b=yaRegHIIiHCnNLT706iLbD7s7IzF2mEkuTEkcXDJXJ+93LCInyySL0MYcM30sdHgd9agyx
	Ym0ikDk7JIxbR3zVrXBpuGqsPK42dcYJoleq+AHTWBrPwItsHZi13gCrOXTTVwjT5+m9Vy
	QnDG5sf9b6GRr3MWI9BFWsoAR0GWxXc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ICFBk2in;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760439893; a=rsa-sha256;
	cv=none;
	b=dbMTFViE1IzQBqCfMzKBoYsXNqYlckHRtWCavzxUGyZHkIFtzTTXgcn8O8XUTT6tDw6JKN
	lNbKxCJkedu6fbC5eR6pitJI+ZD4W7oyhPBVxLhqs4i+ejBbDhxkUjVkV7waJy/9Yq1myu
	mbhPLEsJKb1rnkxVF4YtpIW+RkTn1vU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760439892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9Mvh4ql8Y8BBLDK18emWlEI/npE8s1LEzxvuBeQPUok=;
	b=ICFBk2inemDdyTwCJguCPxlNcWAvlsFG5w+4YhfSqyq2yl9lPGx+JqRDhkWTO6cqZGAob4
	3dUBTrW9iokEJg4Og5iBrwty1rVe0wsgfOWs41AHdTUexrtNktDZWwezQekWE+5fJrCtZj
	j5zPrgmfDatJG5nYIjR/uHx75IUWZrI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-AFYH0NsQNT-rdm5qN2xZkQ-1; Tue, 14 Oct 2025 07:04:51 -0400
X-MC-Unique: AFYH0NsQNT-rdm5qN2xZkQ-1
X-Mimecast-MFC-AGG-ID: AFYH0NsQNT-rdm5qN2xZkQ_1760439890
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46fb328a60eso16834485e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760439890; x=1761044690;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Mvh4ql8Y8BBLDK18emWlEI/npE8s1LEzxvuBeQPUok=;
        b=m0iTtVy9gH5/9zeeltJ9thmvvtlLE5E5KiktoZtP+ubRgRVOO+oBp8cyjEoVn2uojr
         ETagp9j63bVx01dW5pumeATFbzv0xX8qH3b1V3vbnmCnV/QB0ORmDhRu+J66wuM2XBC0
         7sGrVOAvZdvtyNy0z8nbp61KIq+04ZvM0fx99CNs+d3duPjloeg0D1c78iLa0mNG15Xq
         marLYJqOltWU4Vudn8h2Rzjy2TiRK+RScbaqsYjss9uKRn9V8/2TmgRq86JbbDosoFi1
         Jp81EIImHij7fNLd9I04ZRKZFmJCFqDrDyfmX1aMa0YaFq/R0usT+3t/HwLIqP+R3OpB
         AG4g==
X-Forwarded-Encrypted: i=1; AJvYcCWFadYDx5O/BL+X9iJihn8A1oiw6VoVP3pY27OW3fsxjJTBCe6n2vkJDM2caZzqaMydKu088iTM0Q==@kvack.org
X-Gm-Message-State: AOJu0Yy5YzsvTRGo5dNhddg2Itk7Ux9IgsouXC/6W6OSWvAsCVhkfcAW
	K3JbhLHxc6uO9pudUCSbGNV1iDr62pPRjnGQ7g+EtkDMP9QdrOiJEyVg7sm8EVf/l3/R2+ONlmc
	ADxA0ab+TBWeOhVIWAfwjTvHtznXrzRyIZcwHrSIZzBPwBVBG60l9/nGdrPyz
X-Gm-Gg: ASbGncvsy8tnYK0UtgEJspjoT9cof0hEAHz0CDd26yZzefkyiteRtcGLZH/lv7Ydnxw
	Dn0bRCoCX0lEM0tmk4RMKeg/NnCtHkjeJVKVcCNOvqKP38YFXp44gldpUQopM+9ckVSDMS0UEWV
	gU01zhNiLLbfWxHFbGt6fd0JYFw+lxPNnIbz7GvlirvFlvv167usokSxl22YDSTipTWWdfOGRmA
	j8HAIYJsJu0NUWFV/e1SDE7NYfjTJ6OnPplPGUNNmnNJghygyfG6bkS3IalOFbEANlQgZJOA/EL
	uub3LC0jypBkj/Rzuc3F+Jr6nCayKL/CobzM2pS8GbY+r83E5LSobiDY6exeSzjqMx+4u+FEWg=
	=
X-Received: by 2002:a05:600c:3b07:b0:46e:1fb9:5497 with SMTP id 5b1f17b1804b1-46fa9af84fdmr170865575e9.18.1760439890090;
        Tue, 14 Oct 2025 04:04:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzx/Z7wqxSbdzibLnTtJ/UYmUM/D1LJV37loBqc1rTNfI1+V20N8hWD4xaH9pYVYV0jbb3AQ==
X-Received: by 2002:a05:600c:3b07:b0:46e:1fb9:5497 with SMTP id 5b1f17b1804b1-46fa9af84fdmr170865285e9.18.1760439889704;
        Tue, 14 Oct 2025 04:04:49 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb48a5bf9sm235616575e9.18.2025.10.14.04.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 04:04:49 -0700 (PDT)
Message-ID: <34b482e6-2360-4d65-9996-1513bcf12ffb@redhat.com>
Date: Tue, 14 Oct 2025 13:04:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-7-hch@lst.de>
 <41f5cd92-6bd8-46d4-afce-3c14a1cd48dc@redhat.com>
 <20251014044906.GB30978@lst.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014044906.GB30978@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jap3xIt5vuwvZfGi2LraYjGC5d7BxAxnSxfvg5rwlL4_1760439890
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dxtf871trhfszp8swzej57rgu7yukyjp
X-Rspamd-Queue-Id: 13A354000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760439892-206378
X-HE-Meta: U2FsdGVkX1+qhl9sYRRJcUZtDkeDuuSBHSNZj7UkpTDWO9b9cSiSoXr/f49gC1tjW5zgZ3cRs5O1BM0AUc1/KdhhRnd0xs9rX3T6pyUJU77PSof+yGisaoQkWqKq+tvRMzLIv6q7nOIo0XY6UKrpur212Fv9fuV58A1WauWDWMPad7gly+1KutIoDM7WDhnXOWAJRf4HSLnfe7aEeqD58pvHFD8GJmsVRXwNwPsQvfSZCK7ECM51CLl0GIEixkklgVSUrccmLPlcW0CZ3DGOlEyA5/vDUmqbru6Ac9UVyBBC4nb+no1NgXHS5JT/qMl9ttYwmw4rbJOoQv+362DVVYwDuKsM2vIl4tSkWOivaOznarobiKfdn6esPIVBZKOmvEinH7pBaTgKjCmSS+rEpWEssgyVDxkaHROXwa8as/4Znedzor+Kull0VqoawcFx9ec64MFLGNHK30fYVeiF5DA5BSvJGgnNEUGlkDGdriAWswJwZQA3OmovvLe6DQWvDb9vBkAbN2F47zIzOYpVhQIhYaNzOqWDSKVcVm54OFtcHisNWEUyhzyjRganNw26NuyjXKl6Yh2rROT40h4AXFmm7ReEig0EKwO7JcGYp9zlxAdZLxEs+wEpWYbNsME+oCZ8SkuxQTCbx1qxjyJMfBoFQt1MD7XspUS5MKT3AWLw8glZFGZGUWBQv529zVwUcKk2ZraXCkyTHPPz3Ho1BlUvd2ttNAzCaCIvTTlr/9evGUdJpZuxlsrf96jdxz202oZXRnvvjE/2KS6AC6DJsCR6ipMhac90kX5qA6Gec4h/IsEh3YwuQTN5BQCjvYfp+7wdxz3TjOseN9ExV3gnwwx0uZcKRFMJp3EcQ1VNWAl9YpKoGyhtORfwUTjhFTXILs2xRqFW+RFV56COK+lLw/KokhFSFRJTLsJrjjpo2/Age080cQ9izCt18bZUo7f+3QcTJCaNX6I8pqR0kHa
 xqkW0Bop
 M/kao3biWvb8Swrj+S5hZJjwUFeOAHC3zqGpJX38jiuRd5Y2MGggpv5l+qYN21Nou+qnmWSbGGYfqAx/ePofAxZd8RFdRME1bfwydpmAuPQCIzwrbH7qZfj/CnuqOnW/HuWEttOBzdIiB8DLeDmDq1MYakq9T9NhMZZmrtCbZ/vWl9u5USLwI6k+e6kzw4fc9Ntdn/K3rICtbi6mcGBWdY6rlEmTzSve7DHUOTc/G5VYNZWK61EJ0tkf6Amg+qYLaysISIWe8gn3gy2SFwYsRI25uCUR2L8yQVq6NAB3SgnPJKj+Scg7TzM55yhO36Ja1mUWxz3LeSDtcOTPF6s2xFVhq2c1OpDW30dJAafL4vDc4JZ0CoKyb0GOtjEzmquyhpw7XjheA2rwNTXv0+IBuH5jt5DpxLWOzwSXLr+rxBEZmM+4Cxc5/sD68JnTtevdKZz2u4iEqPMW/WT3PGrsz3WrpaL7gvoEySN+Y1XftMd501A4pIlSbZjs/AVPBxUxYpHaC2aLnZJlUZ9KHSQbF0jfj6rkNKekvLl0QdXs3lCtWF1u7RRIOE4zXj8yf74kbV7T0YFaBoSxwi3suklCXTvq6P8biZ1dNuJXC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 06:49, Christoph Hellwig wrote:
> On Mon, Oct 13, 2025 at 02:48:48PM +0200, David Hildenbrand wrote:
>>>    +/*
>>> + * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
>>> + * btrfs caller should be using this.  Talk to linux-mm if you think adding a
>>> + * new caller is a good idea.
>>> + */
>>
>> Nit: We seem to prefer proper kerneldoc for filemap_fdatawrite* functions.
> 
> Because this is mentioned as only export for btrfs and using
> EXPORT_SYMBOL_FOR_MODULES I explicitly do not want it to show up in
> the generated documentation, so this was intentional.  Unless we want
> to make this a fully supported part of the API, in which case the export
> type should change, and it should grow a kerneldoc comment.


Ah okay, mentioning the intention with not adding kernel doc in the 
patch description would have been nice :)

-- 
Cheers

David / dhildenb


