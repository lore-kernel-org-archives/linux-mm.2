Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4090C10F9312
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82E56B0092; Tue, 31 Mar 2026 20:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5A746B0095; Tue, 31 Mar 2026 20:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9709C6B0096; Tue, 31 Mar 2026 20:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86CC86B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:39:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B0EC160506
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:39:58 +0000 (UTC)
X-FDA: 84608129676.29.7036394
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id BA71B1C000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:39:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fwXnNihg;
	spf=pass (imf20.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775003996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlAyR4IsTCd6Wy9tY8fsi0F7XjnqGFSW2B8UQN2ZazM=;
	b=3OG6wEGrwu5FgYDBsMv23E6Smew38UkZyKcClCZpHvb4TqDYxW196s3dTkDw/EmokD2k3o
	dErdeucDJEoJNzcBzWTPeQi0v1nzERGu4no8JDOS99C+hrKlSQrR/hg/uE2tL0gOtXIBCP
	B/vYfQnvkPzHiHjgrCGIByE/BO9tqF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775003996; a=rsa-sha256;
	cv=none;
	b=duoaQu7f4d1HBnblUgGAuQdVcqTZ70hGqf2eWDx6kR3xBEjow9+LIHanSP4xVSzVkUDpUZ
	UZEgSE4Ei4F5dukT3aOOYCevpISSVhzohbrEEJaTMYY3YHULY9JWC/DyOUznMrDDU1BY6Q
	PgVYjALXDuvGk1hXNbxz8QELQNSxeiI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fwXnNihg;
	spf=pass (imf20.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775003995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZlAyR4IsTCd6Wy9tY8fsi0F7XjnqGFSW2B8UQN2ZazM=;
	b=fwXnNihgx1DSAhtOamatFR15FV662OWPCGO6ik+eHZ0cZh7fvhNsP79zfb0EYU+WgLHn3U
	FC0PN8RxISRmbgK5cQChGvL6uLCX1BWQW2dvFzI9CmDjY4ozC+LFU8TNMxA8aKkROkLHYL
	wtIaOO/mx6INWBUfbhG6YpOQ/EpOeLM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-W-IGbPjcMQy2Ir3KumA-lw-1; Tue, 31 Mar 2026 20:39:53 -0400
X-MC-Unique: W-IGbPjcMQy2Ir3KumA-lw-1
X-Mimecast-MFC-AGG-ID: W-IGbPjcMQy2Ir3KumA-lw_1775003993
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-bce224720d8so3964180a12.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:39:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775003992; x=1775608792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZlAyR4IsTCd6Wy9tY8fsi0F7XjnqGFSW2B8UQN2ZazM=;
        b=lublTXosBBWV98kdGwa+tm5pU9V5ktzjtr+omVYja2t1wXZR0AdvCF2RzQZP46Uuta
         G5vEcIGNoHk7glhWXhfGvY6b7Z1KPUJh761yfowmtuUurdoQIq/llDLwoEYsdrzYoSAb
         q4n2RcRw/I8tA72N/duZVFH7/letZ9S1PsmGa5ELISFZ6jeqU9z1TYU5Ksc17ba/cfCa
         JpiKUOtiwMg6t60Wc2FuYonOyiRwjF330HhsCwjT1p/YSbWS9gkQcUCpRF+DP9ZJ4Yr0
         uu9FLjI7tKbUnmXtaXEFPeEun6E5JEuBbYrJNYPafhXNaRjWpW7ZVTdF3DT6PI+A51N3
         Z+Xw==
X-Forwarded-Encrypted: i=1; AJvYcCX4wqJ8zcisiHW+yHmoy2qz780LAbhyFmJnQV33//ZiEoc2qFUFUEjlPNwk+JPDGLW4tGxVzSjtLg==@kvack.org
X-Gm-Message-State: AOJu0YzVAKi8wXuJWxGmAnBYxJfRYJIN81E5zs1K+zXDlxakqQLA2MWk
	kiRsODHRDfriQMr93kqml3HfiUzFHPVkTSycEBp+8lFzWE5WuZrOeMCitgvXDtdZvxE1gs5vcYK
	jTt5bRRY853tRyqLytRLiQREHjXiTbwUqG9+1oViF/0T7814SOXU1
X-Gm-Gg: ATEYQzwYlSvNrx+YnOoLWiZNWvchw3BfXh5TuRlzOOfX1rfksZY5THAYksT7nHoFOvn
	6EpXSgd8TEiUOfV1mip02LK9qcYqR0fzdvdddnDBR/ZfS6Sy6i8oH1pmCCR3SWZM/sx1y7yw8uZ
	2qKgqOSqRAtKM02ABXgfCWcqSrIcgDTTjcmwswCaTN1sdAdC+USRPDb6xPnxyu8f7NuJe1yJyZY
	bW8V0so0uXL6qobB6jyFS+ebAx/KHxBf5Z0W1OxMhi8MRlJPWnu+vGCBseo+50xl+8h8wdJq+Si
	8thdwt8xXykOmVC1fKUI4hQUrB5w/WsWlr2iJzsap/9V0yvHt/J0bph63bIrhGKNcAlQyxg68TH
	IPLYthm2sYdi1JKem1Q==
X-Received: by 2002:a05:6a00:94c9:b0:82c:7767:5bb2 with SMTP id d2e1a72fcca58-82ce898c25amr1699800b3a.21.1775003992508;
        Tue, 31 Mar 2026 17:39:52 -0700 (PDT)
X-Received: by 2002:a05:6a00:94c9:b0:82c:7767:5bb2 with SMTP id d2e1a72fcca58-82ce898c25amr1699778b3a.21.1775003992032;
        Tue, 31 Mar 2026 17:39:52 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cd706985esm4659303b3a.34.2026.03.31.17.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 17:39:51 -0700 (PDT)
Date: Wed, 1 Apr 2026 08:39:49 +0800
From: Li Wang <liwang@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <acxpVd5hQUuGPQCF@redhat.com>
References: <20260330125307.98581-1-liwang@redhat.com>
 <96d14f27-ca0f-413d-8b61-768933ee70ba@kernel.org>
MIME-Version: 1.0
In-Reply-To: <96d14f27-ca0f-413d-8b61-768933ee70ba@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ctke5AyRX2VaBvU4BybD7oxnC8XfWlY2V_GV4nx3O1w_1775003993
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: r7s6mbexcy4i3xoi5rtsqt8gr44jbbi9
X-Rspamd-Queue-Id: BA71B1C000A
X-Rspam-User: 
X-HE-Tag: 1775003995-154045
X-HE-Meta: U2FsdGVkX18yrXRlixeXG5oUzLXv1l8cjmC809rNyv53xuv1Qxp7akGuwjQSRBdlzvJOjn2JL3HUx3wFztB0JwM02H6+5ms2ETS4GBwirAGuLoTmELWUhLxD5+degh1WykwLUuS/33GCBCxNzPb63z+DygE4HdJvTAdDzVAuZADz0L+s08pCpJYbRfYPG8s11fzxmdhKANxiokzsRNAPsSN0RzHfG6z4O62Do1Bw5g/p+2U3HIAqY+8zY0HyRZjLxUe9C5XZbb5NE3gMtGV468HKmlTV+E5Vijf773TSdcvXJhUaQPkArCi2epY6Sb26msizEjQFvEfeavh1LsRf7vnq9E47w4rlR8T5Mb5gUqiKFFNK1xV2nTzIGLPfmZBW0W3ia9AWIo2QPmhlxg3c2YqVknvK8nSZPNNf6dWG4BpYqtz+accxTTU7jQZl8KxGsiKx56CjlTeeOquVD2N1B72PTArGqqgQy/OIJKP+ZinBj+A8vECDbbVJ1K///5L7K9iucYK1iB+E+9geIvpdAl1Eg7in0TW7RKFlcnwZxKqv0a3+OoPnjo3QP7qn0j3PudB1nhIlj4Kb7YFrY/T4AY20pjN0NB/ZiitHFN4LO6isztkUFQsMKBENfsLnKB6azJtLHR0Yzc/iZBc9pPceWNkn2wbPVwIfHwLcIrEPev018j+1vLO9edv+xbin2x4btNeE/inYl+XgzsRIHV+OWHCm6x1BtTGwJPakt5TWWVANVdIEysRbcEgisnHiF5KCB0jX5+sBR/+EoHdZFm85aWnIac1rng6AMn/DuuvSYnS0ZFeJuRmRzXoUfn77tzjdn+DMD5zUWwd8qfIGfoHJJYtdnLjfJBJuwsca176J14zGBAGZ7f6fUd8a6eH5WGXzdac/jMDdPTAVce0zdrCl48KjAe+47C3Pyh6A2YlAVn/UY58nKeXYFmy51bA8nXzyJrGOyBGwQzosHXB3wbG
 WdgAfwYV
 4pzUlZJwsRs4k0h9MviR5Q/WJm10efkLDa9sOmEAZvyeDiuqDMWJ38wrgC3v3c026GxYHbj2qzc0x/oxt9GN9Sy2EwuXDyTzw6ABq/C19BKvCJOTR4hdpRXYEXyLPzIQ01t8089kTg7HnylWloWlEhV5LqKN/2jdRmT7O5M5J4hAuqSwjQGIiVv965TxWWawsIf7dNqDljivFNlJ2JTxPB74C1xHmBuK/XnN7WjLG7yRMB8MdaKRIsbKn3zLj2QmBASgoxx4Ur7A5Q1+vF/5PrtKkFhrh2P5ZBUtmyvbpVyysmcuOzFjCE0aj3dtsB3dnx02F9YxrY3rhdv8zo3ioSgpwF9JLUzapY5ctz2baoMrHTtwgasClfeQhln/t1TvdDOKoxvCR80VU2uFp02okjxUuyqxtpQFJrDr5dkr7QUXMplPFS7QCzeG4AvBrmy3bkynkAE51JdbclvqyXcxdHRb6i4Z1Icqlt52lm4ystHDl5V8wsIgjGD7HUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +static void run_test(int fd, unsigned int start_off,
> > +		     unsigned int end_off, unsigned int align)
> 
> Nit: prefer to-tab alignment in MM land.

Yes, I noticed Andrew (thanks!) corrected it and added to -mm mm-new branch.

> > +{
> > +	if (!check_dio_alignment(start_off, end_off, align))
> > +		return;
> 
> Is there a reason we just perform that at the beginning of
> run_dio_using_hugetlb(), avoiding run_test() entirely?

That will make the run_dio_using_hugetlb() have too many args and
uncomfortable to read, yes, it's more likely personal preference.
 
> In general, LGTM, thanks!
> 
> Feel free to add my
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks a lot!

-- 
Regards,
Li Wang


