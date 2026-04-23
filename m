Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F3DF589DB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECAE6B0005; Thu, 23 Apr 2026 10:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79D676B008C; Thu, 23 Apr 2026 10:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C996B0092; Thu, 23 Apr 2026 10:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59B7D6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:50:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E338B8A84B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:50:15 +0000 (UTC)
X-FDA: 84690105990.02.E5C91CF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8E325180010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:50:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ayoH2EWC;
	spf=pass (imf24.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776955813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9FCzHmWnVVCccSekWVzHWb5njrn6p7+7lqlQWHM0xY=;
	b=DYRp3cLvUU1Jvi5AsnDxvBIdOrDqTOVC6cPd8KGnt/5bp97ZOqaRIRKdYY4DNVLwTXz2vI
	JMGyflnIMytLH2k4T/ogesCD7gt0HEGrw3zqmyF4i2H+8h6VBeVT38g+Owb9ASBnP7Nxsa
	qFKyyGw+y7q3ZIDInU2AHZeeTuXRXZs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ayoH2EWC;
	spf=pass (imf24.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776955813; a=rsa-sha256;
	cv=none;
	b=NtjfZl1Shu9DxcI2oTivQDB0HzbLi9RIb+/MxXzj/Nj0LPUTKHhibTW5dmvT1gVRjZ3d62
	bwEe7bjNvqms+OORLSpQntJDteF04jrhg7CO+F5GAzRl/9CC06xSdAKk83kKaeRGhL8b7w
	jME+3tCguu5Dq4YiR+U1Ng2+sgAy4oQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776955812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9FCzHmWnVVCccSekWVzHWb5njrn6p7+7lqlQWHM0xY=;
	b=ayoH2EWCiJ7GHnml7fm1G7nxCx/5aQDjpCTZEd0eUaaLKuLEN9T9Rx90sgQ6LmNNnALmai
	IRUJF0sTr34s5p/qpwgvFc7UqJx0qosLeht4vnIVXvpsrUM6IY616agnH1SNBWMMojKE2F
	HFwWLCboQ3BOEJvF7rP3p06FlvVr0so=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-7jXqZbDANDSTSp7B3gC62g-1; Thu, 23 Apr 2026 10:50:11 -0400
X-MC-Unique: 7jXqZbDANDSTSp7B3gC62g-1
X-Mimecast-MFC-AGG-ID: 7jXqZbDANDSTSp7B3gC62g_1776955810
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8ee1a909037so702132585a.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776955810; x=1777560610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9FCzHmWnVVCccSekWVzHWb5njrn6p7+7lqlQWHM0xY=;
        b=njpdkG6IH2iyApEdrH85s00/6A4FNGMvUzyVWNsPPzNAGN24zM3piJGSrAQCdryMni
         kxZyznERF/b9928YhHG/opFwr9yYvfVGvWLtNjvet17Qj6VS5mo8cA0CzXBNPzWNyuwK
         2hFreWMzk7TZtRvXdsgUGxy1dD0Bf9b6+9zR7QJtyFGjmT61em7Vlg7HuVjNH9Yx2S92
         pSkM2vKKND6g3IBIrny/taA+0AUTUzbrJRxqj71A/KiReoIMizcKyQIJx6pZhaTzoItV
         0E3QdIW4UvrqbpVrmpEJY42Vn8uifbFeQCsFIrhtTI03B/n9BOBlc7WAdwZjiMYz+qnW
         hqRQ==
X-Forwarded-Encrypted: i=1; AFNElJ+4wXUpB+0X2lg1YUBrc9EQp4+rF220tL4cG7jZFRVKKKWhWsnFNGtHW5t1mnhRAN2RYVVSX/JUrw==@kvack.org
X-Gm-Message-State: AOJu0YxyGMDWi2tNvMbKHqEeLNADtsHOVTQ3yhZUFM/urWLlFQtoDQO9
	ExLJ/B5pHHyG2TDTUUGWZQjnMoWpKnL226WP5uyV2BtOIi5k3+e+i7DeT4xjQQhcGqpYmgehVKr
	GZGOn1mI53ZRTWbcEBqyQ0mtgdHxZhOD/+OACGZe9Fl6O9yUq+9/Y
X-Gm-Gg: AeBDieul3QmBe7gR5dR8dVncaA36BvAUtOrFIiOlv6lCtaUM9fZnK4oMnJkdLNuzt9G
	OkQ0vLNK0UDQlM4B+ZZICy8yj/dISn6Xrbob+nIOqmbKDOeNPBQ1MQ1QHDbJ+AT7WBGCsZ0AXI8
	GrbRISFbBRUk1eFQf2tvYOHqZyN/fOv7GCUh6wcWnUcmc0SYVl4wjRPrmdAgGHwSeNUv0M8LGB1
	FdKfeQ1OJ5DhDIV4vy9obGChtoFxCnZckum1pznKHxop1+Gx5HEevSmy5qaZjNDU6usEXKZl7H9
	vO6iTjaTbxjlkwG4/0P1dcN1K7P80a46l8K4K4pTMU9Q4tQJNqihNk7mIqFq+Zei1zzl/j2a5uF
	+lAJebqsFRtG5QCPu4J2CNZB4bMy8mvATtgc9cgzR/KVesviQuPno+7wZDw==
X-Received: by 2002:a05:620a:4084:b0:8dc:eca0:35bd with SMTP id af79cd13be357-8e78fa1dd25mr4108116285a.5.1776955809709;
        Thu, 23 Apr 2026 07:50:09 -0700 (PDT)
X-Received: by 2002:a05:620a:4084:b0:8dc:eca0:35bd with SMTP id af79cd13be357-8e78fa1dd25mr4108105885a.5.1776955809008;
        Thu, 23 Apr 2026 07:50:09 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d98c15a9sm1850297485a.43.2026.04.23.07.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 07:50:08 -0700 (PDT)
Date: Thu, 23 Apr 2026 10:50:06 -0400
From: Peter Xu <peterx@redhat.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aeoxnuGKO3uqS2kG@x1.local>
References: <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation>
 <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
MIME-Version: 1.0
In-Reply-To: <aeorZMvKwu8zKX5i@thinkstation>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tmfcu6d4t0a774KO3vOaEELYlfGG2VUxBf7lrML_bJI_1776955810
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: itisrqa48s8qo3dp6rs996kpinf6nkyq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E325180010
X-HE-Tag: 1776955813-546489
X-HE-Meta: U2FsdGVkX18wVJV4d1HOGYUHqkYorU0tn5mhXj73fdf3VuMkH1rRNAzw/oFQqsooI8O9qWhEpediOPMlP3dOcHYq+J1+P0T7x7RP04mDo1ahELtimuNru+QtZv1VVIvnw0U5vRxFWDEndYsPy3m8BwdufeRsHNG/eqHNxMcFe5JEoqKVP0lUxz0NxkT2wq3Z/4ik8roOffEzYNnYMUceNRXjSARMbgqGgAwvS3Z9sh0dzPDG8EeLm932SOaSKe1cru9pmc6ViQTW6NNNVHBj/HXKUH7yBARzcPb3rMszGGxx3TswfdOX1osskKR2WFIK6FvPB1dPH17F8vHH0TD3OoHHdl+yIcN4ljSoTX/6MC3yXfAnFu+K5frzizBoH4b/HlJBJrxjkBjhYAZDEBTL6o0nDOchAkaB9g6foc4i8picaSNFQVT1UgbzcE6fju9xch9XIR6/AjQr/bFdjWpMihjV6Yl5n+YFm7TO3coxjTsUh9VpA25T2SnsgbRd5ok+/FK6WU5zx8/JrXUFdeELTcae4jxwi03B0yTblAbaYUSu+AuG1wC6GlnKE9r8pcMXsvevLwzBiA4LTx5eJimaaOSMVGNCUq0WQKaDa0xLPUBgDkOkq/mBHR3PaHxo/TpfBjofGdg7Jh7zvu9ZmVKXMYn8+WYny6Cv6Nq51XWiLZ7L6VveuwyC7HOd/OvnIbY+1A8TcIPYntNP823braNMq/EzKxP2QOkfCUX4bTQL68EBGi7w77UAbhCJD6W2/geeUz8ybKCYNB+31B9LxKhCfAFHpbYqqKIoStuJ1cF6RAIYOhk+YLS+FWbZz9UgrxO2FmgM8if5l+g9BPZ+0MJt9JnzkBuQQHhO+bxwQNpgObaAL76ycSo8wbnEabm6jVHWlfUoE/TYLxRuWM8Yd34GQsnZrNdQTU1B/y51nO3MpvpqyGOqkYm0r0suh/lLQMU8Kpub0JdFamXgGd2G+Yk
 LS4kG5u+
 VE1dTgESNi++p5a1vw8NZSFU7ioxMnsaO7UUZwJt+kEKHB0MIfzUlqDdVCLBU2YrT6zeidsxqBOluvsW/gqZ6opgBKKZbcoxtZ+ndMfAv8usxZyx4u0t5aVWUTnuggHJ/08DWD26DtavvDyE+YSVZGimxSggEw58oR38hiS0D/TfMQLixBc+puEt1Y+y9jlCEvWx5L4u5+97dOyExAMM+xz35J3PVqMAxmifBxLb6HHGSMPxceJVSBe+ep0FcXHCheo5KfrWqi2fAANvESU6nxXTx2d3JxsX6sE0/IrC+ZHrKEhbtySRJHyFbbzvuIn3vbBDo2ZNiKssNeyD0aWSiTXQOA61OYKaju1u3nOo68oozZMMkUuiwxBiS2rrnklLBvyS11p4uQwMeeCkay3lHGY1yAti0GzFyv4ba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Kiryl,

On Thu, Apr 23, 2026 at 03:27:11PM +0100, Kiryl Shutsemau wrote:
> The patchet is pretty good shape in my eyes and will probably drop RFC
> tag.

I still have some high level questions not yet got answered.  Do you want
to answer them?

https://lore.kernel.org/all/ad59TxAHNwFWH7Cc@x1.local/

In summary, it's about:

- Whether we have explored other approaches on page hotness tracking

- Whether read protection is required for an userspace swap system
  (e.g. did you get time to have a look at umap?)

Thanks,

-- 
Peter Xu


