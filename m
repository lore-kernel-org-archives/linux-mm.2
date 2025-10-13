Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 568E6CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902588E0037; Mon, 13 Oct 2025 08:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA788E000F; Mon, 13 Oct 2025 08:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8988E0037; Mon, 13 Oct 2025 08:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3A18E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:46:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 224511DFE6F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:46:28 +0000 (UTC)
X-FDA: 83993064456.12.85F10DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8565F18000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:46:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bpz/sDNb";
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760359585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOWtspxQFntLxn3tZgWb3b+wVou4f2oHZHARZ/GY+qM=;
	b=TkL4H3m5cvEun5wIEPrTVAEPCDSKdR37hcMvVIM0knxNaUT2VJy2nMoYgVSEHoAouKKn6T
	nEf3yMt/vRuWVCugkSgpI64XhOSprkE6JNALlqRxqcCM8CzdCUZ7L9u3H4WXHJbipGbWtE
	UN945TrK98y+79tpub6gxLsUWyMWruo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bpz/sDNb";
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760359585; a=rsa-sha256;
	cv=none;
	b=boMRTTBP1G68ogrSz02X07sCu+L2qU5YdwuOq9gX6Q2o0MNSbvndj4y/4xeKrS1lzmOAiQ
	lcnj1Ig3mtoHENd2NZ/ZDboendfygptFkZdvS8wWqYLRElC9ueCyIarhF8tTs2OhxcnmLk
	148MpmDGMQX48GeM2iN3oc7qQHeMfD4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760359584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DOWtspxQFntLxn3tZgWb3b+wVou4f2oHZHARZ/GY+qM=;
	b=bpz/sDNblwgTSGTWZo4MlbGOjBOyEfFRC0Hx20fuPhoQmlcrM7ff/rI50to4q+K48NPR7d
	1wDzhiRplMyheNHMCl0EuuDvOBHCKV+CFsbIbREARqfAWMz2HZlBgbtsrvoHCIKGZO2Kls
	rvy635xVERGNSpBrSyhZMRQYY5MEG6Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-hwtqhoswPAqYZTl_DwqSAg-1; Mon, 13 Oct 2025 08:46:23 -0400
X-MC-Unique: hwtqhoswPAqYZTl_DwqSAg-1
X-Mimecast-MFC-AGG-ID: hwtqhoswPAqYZTl_DwqSAg_1760359581
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e4fa584e7so24912975e9.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359581; x=1760964381;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DOWtspxQFntLxn3tZgWb3b+wVou4f2oHZHARZ/GY+qM=;
        b=jXP4xA4VjdsbN0/vwMyrVw/FWuVvzxi9GhzPcq4nCMS37w/bEXz46hLD/QLleR8ccE
         oj+tVcvWFPYrdF8FABtQjIu58b0D/GQlMN0fyMttN171vPBTPRS0O4+PQa9rfYdGSKnK
         axEMTz4AKLO40lYp2d7Rg9/+rWXEUUhJjeHH7kdcGZZby3y2LAW8tizJim51/ov69iTD
         2Dtsk2CMEScyewBrwabCdf7TtdK+1oFzS/cS5KI/110ZG0Hm+p7GuoweTXRvVEUglMJB
         D5y8qxy4ot4rgtRPO+VRPZG9UUNMC2H3gPjHQPxSPYKhyXyLg+HtMrl2uhYZAuXflOgU
         6ncg==
X-Forwarded-Encrypted: i=1; AJvYcCUYczsC83414C+xNvjdE14ExbOfr1Wusizj60eNo6aB/JABdyXsrloTuS1eDa96XFkVe9bYZGwKmA==@kvack.org
X-Gm-Message-State: AOJu0Yx8iyl8+omOBE5OfzlMriXU1aqaltDMx/RXK855BHehLSZZvrHx
	I1mbmv3DLNe9KM72WRcRsiby7xwDpLwXUvXU4uEbKiTpy7JqhpSXB8kGxQVV0AgA9dBczYrMi8p
	GymEGR+GJL6wqRRGAifMWroa8wqMoaFvP46iNfIUwpdmb2FD8P8fD
X-Gm-Gg: ASbGncvkNKdcwwnV1dJIOv3Tm17lYN57vWLHeV9utXNMN7HQ3ktusAJxLjWTYN6yZ9P
	ZsuT71UxTl0KNJc2n0/og6UK0SqeVSA2Ztr3B4oN4zdpHncyKCF4eCgG9eIaCWSYlbKSs6tM21Y
	Ghg3mnsKhXI3cTrDD9SHy3fF2HEnYLT+tGqyUQPi0OwuSbwX5eLoVqMNrRspc86FjpiCQxm0wED
	3Ld5+PUvB6JEkYnIsMC7PRwMckRieOTuwsKd0M8uN5ZyFGPJ9s6Yox2NAdnPD02Sd6dmEo4nG/U
	032ztyJuAh3syc4KcvELZ7tslMY99sSKjqS0kDTY9Knzs4f/fv8Q3UU4woBunugdXrijgxePfOw
	Hshk=
X-Received: by 2002:a5d:5d02:0:b0:425:7c1b:9344 with SMTP id ffacd0b85a97d-42666ab87c3mr12660084f8f.15.1760359581532;
        Mon, 13 Oct 2025 05:46:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8UhyE1zcOzwvyZxntvIRmTrppgW1S8a55KmrUdjOiVEiYyQgg0jajjwhannoKAXqQXoZQ2Q==
X-Received: by 2002:a5d:5d02:0:b0:425:7c1b:9344 with SMTP id ffacd0b85a97d-42666ab87c3mr12660066f8f.15.1760359581095;
        Mon, 13 Oct 2025 05:46:21 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e82dfsm18142892f8f.52.2025.10.13.05.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:46:20 -0700 (PDT)
Message-ID: <a5ba4cdf-5da9-4e3e-af06-ad4ea5c3f659@redhat.com>
Date: Mon, 13 Oct 2025 14:46:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] mm: don't opencode filemap_fdatawrite_range in
 filemap_invalidate_inode
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-2-hch@lst.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013025808.4111128-2-hch@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: St3OXWrcEw2sUdy1bxg9KzSTvHex-ML_TSqodS48KIs_1760359581
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8565F18000C
X-Stat-Signature: 386kqyowonogxafnh66ii69mkyu56uwe
X-Rspam-User: 
X-HE-Tag: 1760359585-580578
X-HE-Meta: U2FsdGVkX19QgJ1ek1M2AUKKICgd6vO6OZRxjbfLk3YLRA7YN4rbNMp8G90Z4Km8Y1Xk4OpA4RFy8Y4vF1x4rM+zv1a6vYsDWZzihg8g6qsMaj2wc+X+8699PW4cNie0ljU02/BZ/Kp6RAM5OkUVD9CtrK3WhOMUe0187Rj2IH5vv+bdBB9NXRc3csLNXWTjUdmtK4EPEgkYN7jdtyVMilVd3+trdGQMRYy5vzIDhzSrGzoPvCH4bXD1RgH8taqdYkavSlJo8w8uNUW+Fp4xN4Z6o07H1mE4F7NZogf5qwndLqXKmmT2X3I6Q9IzDjZQ+TTGN6a6MMEK/Os0d+LiuepJGl9tU2zjatea4uPa5uOFAg/0X2W8n2dyfag98i6hx/eIbnFSmkebLF0YKyTgYv3IpDUb8OjGLgZxpUU6pungKtCP2+7UF8DP5TkiaVgONuxNEDpNz2q9u/fgQ4QgwVZ4ztGn5bG2jSpBoMKXsVLr4KmXpTdDuTcVLJAphgQE7JiQuo/Dp8/+4LqZGBkzt9a4l3FIv3Ds2Sx+QaRDT5ndheAr0nKXoBCsGfhjb8qTXZFfXy6zAdxpRBNXGyFL9ilgE1m/izB3DQlnm2mbyU5Bqft1uOj4hGtLSEUYkG+VGGIh5Dv+AbaZk4y82p8hZHtDemCHc+PQO0vt2121QcZWLMJhrMujjiABpLl3GlgXPsfhB/mj1sScIPA47g6Dpljs8hdWBcI+bsKgcTxxv6ZnmvZBNJ+XbkFn5PtLkInzPzRhg2nzQ7N57haFgGCPoc37Bq+UgeVXtUjCVqfCLL8LQAFvf1AQ2wnJ/PbNvzmZXaGPmAjdqlJuV4PBiPLOLDNtZQN5A/F7ov5WscofTWO2fcfkiBO2L1GOTt9DORbANf+GBjfKQjnD0UaUspkrOCVaLFL1ui5LNvHp8JYQPdc9AHOA6U97T7wOWDQBYuEtjXtjkR89Sc8U919RXdH
 g20SFxwH
 UX/b819jrj3+g32BxXnTV7KEm30YwnIALmtujgUULYmMK6ISUWKtMdygW0jtMqsY3/yTXmqgMdARZ8nZlRurBnHGeGCy2d4ru6aJggIlwva7+MQOx2gTfipuial5JIwqgt6lwi2fMOkRtxuKf2Lma1jGhXLAg0Bu+U1i+WldzWsm0kkicHfFa2dqSpwjt26M9CENxUSZtQXQVndgRYaoKB86+5U9AkxbBddxERODHbazFsgo6uOmf9Lwjc/wO1I51jrQJytFpOxJDT9wziXKlScIIMBmesVo4aWtBYXjGAR/yE5HtP/FmqJOBceHOtlVWv7aYpi8QwHK3v8I0Y3oA9kBZl9Eupv8aAKn+PETFIbF2gdI8CMZ3DBYHtuxX/1HibsUbwltNz5vBMlFADs9o01Jqs/ryzH0CNVhJjYUN8F6kNH+/fxKL/XYHC4laAtOzwAc7xwSLrrdbV5dg/MChrqT5KNXCtEAhTvHgX9JOhC7ydUCrvTukileqAhFtX1+8Aie1mNJtzAmH9UiUDm4tIqEgx5fMi46cSutVzTfAGPhoKaHAZkDEz0+micqgbwHG7lC/hFx/MuYyfW2MPbJLf6REQKEp/ivx2WxsdZORS9pf4O5w/kc16GwldgFqpZd2UjqC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 04:57, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


