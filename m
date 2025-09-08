Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E8ECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFFA8E0013; Mon,  8 Sep 2025 11:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470688E0001; Mon,  8 Sep 2025 11:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADC08E0013; Mon,  8 Sep 2025 11:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28A198E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:06:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF67756A24
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:06:36 +0000 (UTC)
X-FDA: 83866409592.29.86070D4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id E702E20011
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:06:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xxv0hQdM;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45n0EoG+NugLPzExOpw0q6NkAjxX0oJ2+U+kNdZODK8=;
	b=WfGmV7ru3dfG7pHAXz4eia4E1VWqJXOReK9pkpx2Zvv5rW6ZfqB/hO+3sJuZIclPZMvjir
	9uyIAQWNlK9CXYI/XPIiTFj3tE51iodm3uathc476ZMrfE+oTZ3ZhgcMe86tfjvDcPvpGd
	1MOIQlVuqXDQQJR5KXP9LvVt7uVZFUg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343995; a=rsa-sha256;
	cv=none;
	b=zBoL4UZsuMzO0hekv/AoZhzGmVSAzRYmgqgPN9Syy4WgP+5YF3oWUQSNhqiRHpS0kiAQY6
	b6/FjtRokGnparlyLY/kB8bxsHO56kCP/wlVbP6DQpSNbT2sqM2ljOmepWUdYB2WjledMU
	4fK6fWgcjGbUtlf+uRDfo/HSgztfohw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xxv0hQdM;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757343994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45n0EoG+NugLPzExOpw0q6NkAjxX0oJ2+U+kNdZODK8=;
	b=Xxv0hQdMyAvGwJhvn5zqzeIwtPxfX6V7CVq4zzKA1pPlXTpwNFVVnwZqHioD9yqFZ6pUx+
	M3ZdUV2ilRTeITtM5HXC4qwNyZZ0WXlnAbqSdqETaJVBDSPwt4IMnj2Jsw8mdg0xEOXLTx
	QN9GQyHlx64mdrhj+W//hx/Q2nmMvxE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-Xf-DtVLQPnimMlKeA0rGIw-1; Mon,
 08 Sep 2025 11:06:31 -0400
X-MC-Unique: Xf-DtVLQPnimMlKeA0rGIw-1
X-Mimecast-MFC-AGG-ID: Xf-DtVLQPnimMlKeA0rGIw_1757343982
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1E37195608B;
	Mon,  8 Sep 2025 15:06:21 +0000 (UTC)
Received: from localhost (unknown [10.72.112.11])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 046491800446;
	Mon,  8 Sep 2025 15:06:19 +0000 (UTC)
Date: Mon, 8 Sep 2025 23:06:15 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] docs/mm: add document for swap table
Message-ID: <aL7w57kF3CCDGd9e@MiWiFi-R3L-srv>
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-2-ryncsn@gmail.com>
 <aL7NrhGw5ftOXUZs@MiWiFi-R3L-srv>
 <CAMgjq7Bp-buJfH8TPCxBiV80rn=zrvucwHgSCMFuS2BkUWkrJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7Bp-buJfH8TPCxBiV80rn=zrvucwHgSCMFuS2BkUWkrJA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: 5686w5b1yfrxkf4m6i9ofsq9scg94s3k
X-Rspamd-Queue-Id: E702E20011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757343994-891108
X-HE-Meta: U2FsdGVkX1+R29AQJwm0uhqDHhR3aDPobgI0/mUWRc6n+vLP9PnS0PrtjbfCtLpk5XfulEyGeIlOsGehziFq2cTDNJaDHij30MB/SBV/3oklkXVyrfc9XBds67L7w2xg4m/dvJ395gDtKH6F/C4wMijg1dBCdCen4FAe+DZJ0Br7WQDXsrl4gUNepQiTIfVW30OkHNTT1Co+bUV0HT/ToqxJ1MWDVO7pSZz8h1e4jUmYOxZgacF8TAGtefIHpvcvHwC37/ehybarYcLy/T2QYLtqq0bppWBP9wya3VMWQixpcHvJy2p8NwXvHesrvdJcG3WJ7dsFXFxVQLOGM28Xi6sABDcq+2CQ1Bg3Y9z51XBVx1hE27qdtuG9/HAO3FY+6r1/pl+AMOM9wZHQwIcfLItgFT8FRVUu5RFLsDL6OwLibutt1KZ8kxhOh+mHo/Ka55ng3NA4ogwpHVtuoLtYO6JkiL8ESPsiEIaf/ee4xOU+boQXN9RJY9eKNB2aB8LHGQZkyLiSUBh3ZTMMuDWZcalTqlD9Y+5NhF7WQi33KUqAPbqPEji17sIR3IdyT9uMIEM0SPApcGwR7d8S3X4t8QBYw+/DG/RtDsL04fp55s/8brUDZeNkLwHGSBAuZzeHYG3EToVhYZCBBGQRblWbXo63xam/mCYPunhZh8BhsmSsy2HufLl5zJmZIbN586ZfJYIWolu3h+XdVvDR9mfrHE9p3JpahhUqrj3ehLFnCKtnFDQewJf/HG3Cvr2WO9tyyjkMT8BNXz8jXQSzNVmPrIz4TJMrU8I7jFVbDRFLOmU1QlgYiyevqzG1h0grZsIJ9x/01Or9GWo59pk0uzXMUVS4ARfsb5zJcrpZOss+man0ng/wD49jFbq9rc5cBkFi6irMX8vyZRLok8ruS1e1zMAbkH59QOo/NhsCJhy4UhqiPEdIv43uhiYIKbNAa5XUG8+2ktB+f8QuyQUBnod
 kCU6I+R1
 JdixLhemtIVw+9rymMNOg0AQdWSk0uZ1KZnZzMSGXWcLTV5ClAJrEqZP8HHBMofjVkYc78hnRCDdUAnjgEFiMrae4pTVLe358jCTfGKizJcTmXy1nsUbCMSfTwEmGYQrhbZwMlUqh1yImwgKdVrrFCXn8WtkbhOKCL1zrBwxX4vuFTWWEpBEmXP4MJVLMlvIuLbOvqlf3C2R6hMEqov594r7kLdP2bUv2r+HaVPN75vCVRAMFKYpiJkpM/IOeZJigd+05ZLBWKRcrtkaIqIzQVFhkK4shMQtNfvzko6W375lCBajFR/t6kNgAONu2s2RdPBb1735I+bOiykKGXck4xBojFi/mTfHin/bEPOPtVaEJLkxSatfSJr/N9i9SJaPwVkI+9AQWgYeF//9GxuvJw4kW9p6d2gpRIqJqenTphFC1/VoIaGqHLwTEGBoc9hIxh6WIRG7ldv/DwGq6826Etg+pQuOHZ3ZPXJb+ILA9a+bil/Vo54pVYkWJ37fd0ybxqWVHIs1ZamyRjs0k37kTg2p+qLR38KHvpWik3Ie7Zd2lHLKRuJDByH0MKyU5J8Uin7IkftjYXk812OY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/08/25 at 10:27pm, Kairui Song wrote:
> On Mon, Sep 8, 2025 at 8:54 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 09/06/25 at 03:13am, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > From: Chris Li <chrisl@kernel.org>
> >
> > 'From author <authorkernel.org>' can only be one person, and the co-author
> > should be specified by "Co-developed-by:" and "Signed-off-by:"?
> >
> 
> Hmm, that's interesting, I'm using git send mail with below setup:
> 
> [sendemail]
> from = Kairui Song <ryncsn@gmail.com>
> confirm = auto
> smtpServer = smtp.gmail.com
> smtpServerPort = 587
> smtpEncryption = tls
> smtpUser = ryncsn@gmail.com
> 
> So it will add a "From:" automatically when I'm using gmail's SMTP but
> the patch author doesn't match the sender. It seems git somehow got
> confused by this commit, maybe I used some sending parameters wrongly.

Then you may need to remove the 'from' field of your git [sendemail]
section. If I git am your patch, then the your first 'from' will be the
patch author.

> 
> The author of the doc really should be Chris.
> 


