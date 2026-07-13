Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67CC1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 19:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31FF16B008A; Mon, 13 Jul 2026 15:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7AA6B008C; Mon, 13 Jul 2026 15:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0596B0092; Mon, 13 Jul 2026 15:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFF476B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:41:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E5C812019A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:41:12 +0000 (UTC)
X-FDA: 84984771984.19.6378897
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4CEAA40008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:41:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FeFMp1ab;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783971670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLh7SflYriIICq2322YWz4Oz4v42mpNRc7r49x5w7jo=;
	b=FbJf9BdDy2Rm2frerzd5/GaRhAdoIqNf2JiMKV/Nwe6Vd/+yqDRNfGOo4pUMvwmwbaIVbG
	/OMzgQ8gd4ZO5UHJ+Qdun1DKSt55V19+yqwc0JpGUh+RIYbT0SprwyDwbkh6YnGvRVsnSx
	2J6v8MQHxMKVQdUKA51f51C17QAwwfU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FeFMp1ab;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783971670;
	b=oSO52r6+tqzniiPqPJAb5uCDrUEq4qLoGjQF600hzv3OvD55KX/9yjUVWSIAfSQbdPgNUH
	nF0vfPdJfW4d9uq51/CO/ACRLwM19KUENJngF0BPhEWa2GxGvOopY1iCMqPq44ArdA61uU
	f9XcJcPb4JxiH4Cp1h5PJ5OBGFnMjNI=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cede6375caso35415ad.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783971669; x=1784576469; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WLh7SflYriIICq2322YWz4Oz4v42mpNRc7r49x5w7jo=;
        b=FeFMp1abm8vKmTQ0iVMxdXo52Ccm62l8nLkHwheH/x9W7QKSrUOwV8Sx+WLegXRAe+
         VwUw/orzvtyG/Httb4zoE0HSB+rlOy6QAh2liS25GKAiOoM0sNQREtafsO09nYLgnBy0
         TuyPodKiDnV6+wqz8sfk2mjLXWjRQ9UBL3T+45eIlrF7SlyOZHWX1otG85Szb0fS6wnP
         xMvqoPYQlyVq0zLEl1BiS29qxvoBE2usL7Vr466Hv6rtIWpbhWRQsMvAxs8W+9RCU5J/
         i7RKtzY60rNXVc34tOaeqpUebEwa/YQsHgnBrR7uAJ1og4H8upL4VE3MEuqZ+ccB2VAv
         Zmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783971669; x=1784576469;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WLh7SflYriIICq2322YWz4Oz4v42mpNRc7r49x5w7jo=;
        b=ruIsbzR1WJox59Uk638E/FdugxeAKEGg2/2Er+r5CmAT+605jRn02AUzKezyiOdqJr
         6+UL36O8WxF/B/ZAeOJ/2zVq9KKpCgEHZaQTMzQ6XSMF1aWsGh1ytxxthsPH2ubU7Rdt
         2gzKfzB1iRNQMMehwtnsd5QuWOzHLcPAVmX/waky9oBhlnnJJ4ucGbBYIJyhNXY86rfn
         RCmL4KRwdUllt6qtxfVPF/ORlCCUB5wsqqoNUG0hmxCc6YtGVMkmXfL4tXXKOA/GD7OT
         klR2qIxB2zZrfA4ryUNNuv/QBcC4kNdr/pXanSJnxHFyQsz5V4ccgBcrPBrVrvzEA/YU
         BADA==
X-Forwarded-Encrypted: i=1; AHgh+RoJIpFPIOv1w3hmcSM8F/ezb6VgWfLlKfGAW9JzLg6V85zQPlhu8yAPWCVi6l3I1VEgr4W2f9ADRg==@kvack.org
X-Gm-Message-State: AOJu0YyXQQtgslQtMmrMO4N+wEYR1BvvTmy6talXu64aZddK4diRKg2v
	yT5INlhKbrJ1LPgmfCa5yCeVjHBcvX3nUfqZV86lib9z2EqQh++3J5KsW9MnheYylg==
X-Gm-Gg: AfdE7cmGQfvbwVuUiXE79fpkO/NR1fywNQiTaX6TfzHZWdHVsQl//lzMZeeJTAwLPZR
	nyZtqFE3FSzpB709wnbhz0vyWMIpqOTGD6htsHFP9Smcyw/vMA8r9t8SItSFy6tUlboa+hbvDby
	KD/a33VmIQlshfw1tXwUEvNOT0liPzR3KiFPZBd2xCQnqrgVm8xCqRGLiJG4L+0B0kL6oYKGPKO
	pd3rcr7EtUaBrioY1ZIdDGqHPb6AASsktrx9/EBXS9k42MgLrh5If0VX0jIafFtb0ZkMNQ/BBpJ
	0wWyxcIhgj9m6p/B1lIkcXvlczG0uTX93D9UbkZGROIHlDPNycecYD88M1KGxZaNIZAFZAyjxxD
	6CpI2TpMF1PMnfWdK3PB8TpwA7tlVn8DDRxA8fGbG6+c/Ya//DIPrOZE6g2fsC+q7IlOVNqeGUi
	0XCGrr5ErS9hCL101UwleWztcgdgYekHPY92P753ZiScaHy3IQXTJrpcbCprRzP8+tvGAfNXxVB
	+8Tc6tMSzXr6pK4QesNSDioj8ucqpRGdCPqtsgMiRHsoICw5b3cDA==
X-Received: by 2002:a17:902:fd83:b0:2bd:6dad:3dfa with SMTP id d9443c01a7336-2cee1ccc432mr2429565ad.24.1783971668691;
        Mon, 13 Jul 2026 12:41:08 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:4c33:68fb:770e:3e89] ([2a00:79e0:2eb4:9:4c33:68fb:770e:3e89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f6c158bsm272977b3a.38.2026.07.13.12.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 12:41:07 -0700 (PDT)
Date: Mon, 13 Jul 2026 12:41:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Link Lin <linkl@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    "Michael S . Tsirkin" <mst@redhat.com>, 
    David Hildenbrand <david@kernel.org>, virtualization@lists.linux.dev, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, prasin@google.com, 
    duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
    Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, 
    ahwilkins@google.com, Greg Thelen <gthelen@google.com>, 
    Alexander Duyck <alexander.duyck@gmail.com>, stable@vger.kernel.org
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting during
 PM freeze
In-Reply-To: <CALUx4KQ=bYTpDoDAZ+iVb7Ehaa0LmyPDsEWk3xFFmTVYKrpAUA@mail.gmail.com>
Message-ID: <59e3dae7-a203-2e1d-3b65-875b7e0e122b@google.com>
References: <20260709224330.946683-1-linkl@google.com> <20260709161253.6b5e9ba349f70a3ebfb8180f@linux-foundation.org> <CALUx4KQ=bYTpDoDAZ+iVb7Ehaa0LmyPDsEWk3xFFmTVYKrpAUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: gufr1t6jpc1y9yinsyz5r1wem5dfqjyw
X-Rspamd-Queue-Id: 4CEAA40008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783971670-928906
X-HE-Meta: U2FsdGVkX19jbdQele7jnja6kylneKygym+OLDuEhUnFkD53304FsR8d85w6GkQBVfWroXQgd34fQQiNedZJ7kO5ZXKCyOug5IIbsS7Hvmuz1tDhvlhoMvzZgtDsDP2dsvxZa3b0Ng1AlknurudCyaKVe1KceNwxF7F7wPJs6VVZIUGs6vbwkg9fc3+Zg0FnOkplmC+R3t+L0nVHTgpODHE2v6q09d90KJ+0TKIvwkCnkE2k6yTVW2mRmOiChKJr6s166gpvUN0MXeYg/pEQ6/s5EvxnCw9TUu7R3oYYuvsmLtAgt5l6iVygUzMaBVvWsjbeuXhXl5jLazxs99MEFsNg7hOE5hHzovzT1ytruv0AKa7pcNuva97P7N8godcWcululzO2E6v5epMdS7xlNwr6Se622cZfv1qSd9mlwfaH3/x2gaUaHWOVzKLza/rzRAXh+ZDHaN7e5u9DJpYx6YkEWYbPDyczU3vCUXGT3QxVi2ZffF+OzSBDkLC2z7zKV4hjJ/4YlHigJkn2uMzYq2dBTUn4B/8YoDmVlVTHbLkMWVi3ks5XZSxHdTbL/0yIu4sZRDOiCMsM6zZkWtSSex9rfbqZbU+sdRnOPYLrzg1sdgIHKAl1ww5tEQYOe8Hsci3KnRoseYsY4vZGFibAnbJsp8MRw2wzKOij96GSLMS8j48KwW5bgnbKkLzdlAxOIoa2Z9x6rWdNtC6iCBXNjN0b7fFfLEc8F97WK0DaMiQe8SVp5PovwCHFUqx8tUlBJXJOq2Vj+tlZY8t6RKttDnZn/A3DxD6gm8jcZLgFJpTnApT97rvzzL5+Vwf/BOGxYcYh2j/JywCSUBOjZ96ghqE8utE+/hE9VzUEvez+0nxuENrP9B91hHAuGHKbikaqExKk7+0wO054rG2ePgU9A081c0+3W9WU2fKl42yzJ8p4uP12hsKm0SywyeBXknD+g+qked6oPBu0wjtRPKI
 qRXQ78Bn
 8D3IMP9DVbdvsGiBFsHaKQ17SDwg8jlaCPPTHkBSLGjaNC0xF6zvffktBgz9qPg04MFgIbhn36drnaF3mSJIDTtfSgjOOwNtqKhCU1QJJ2cZn7gr6jdoLGnD+UiqWVS89y/OQCAc6WIgHTcuFLN24b0iL5YeVb/XruphL1X/3TTNeh70bhCpb/Y3GKY9D7InW23mLPFCgrgpqiPHkd9Wh8RgcDEwg68RniDVQTEm9wEscpbv7Ycngwtb45hdvEzbAMOdguJ+62Ih+NBVJnaPB2eX/m8bWaQ28Aa9wgH5/dFn18vGeIWshRKzXyd8lv2Y3viwqBsc8kDzz39QNlc0ZQdkS5yXvXkc+D0nyXMuRUUCmhH7CWna3fr/pu1HALHVK3iT/P2JJf2LBVzBi9JGVNnjHJDG7xb7mRCzcU/6s7qUinlt4wFjkIuZiZFya+1LwLU4bTrU8R+lC2LWp4BSDDYH63VYe/mDtCawkI/jZc1UoRyJA2WbdZu+7SN5BqXnHbRy4qTHjXjSBhJcVGc7b4NSznldQRkGAkypq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026, Link Lin wrote:

> > > Fix this by:
> > > 1. Unregistering page reporting in virtballoon_freeze() prior to calling
> > >    remove_common(). This clears the RCU pr_dev_info pointer and flushes/
> > >    cancels prdev->work on system_wq via cancel_delayed_work_sync().
> > > 2. Re-registering page reporting in virtballoon_restore() after the
> > >    virtqueues are re-initialized and virtio_device_ready() has been called.
> > > 3. Unwinding virtqueue initialization via remove_common() in
> > >    virtballoon_restore() if page_reporting_register() fails.
> >
> > AI review thinks the patch didn't do the above:
> >         https://sashiko.dev/#/patchset/20260709224330.946683-1-linkl@google.com
> 
> The AI reviewer might not have parsed the entirety of the fix I proposed.
> The patch submitted definitely includes the changes to virtballoon_restore()
> for steps 2 and 3 (re-registering page reporting and unwinding init_vqs
> on failure). It seems the AI failed to parse the diff correctly. See:
> 
> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> +               ret = page_reporting_register(&vb->pr_dev_info);
> +               if (ret)
> +                       goto out_remove_vqs;
> +       }
> +
>         if (towards_target(vb))
>                 virtballoon_changed(vdev);
>         update_balloon_size(vb);
>         return 0;
> +
> +out_remove_vqs:
> +       remove_common(vb);
> +       return ret;
>  }
> 
> > It also might have found a couple of pre-existing bugs in there.
> 
> Indeed. Regarding the first pre-existing bug found by the AI (leaving the
> OOM notifier registered during suspend, leading to a UAF if memory pressure
> spikes during S4 hibernation):
> 
> I actually addressed this in the commit message:
> 
>   "(Note: The OOM Notifier and Shrinker/Free Page Hinting features suffer
>   from an identical lifecycle flaw and are also vulnerable to UAFs during
>   S4 hibernation when memory pressure spikes. This patch focuses on Free
>   Page Reporting, which runs periodically, to ensure clean backports to
>   stable kernels)."
> 
> Regarding the second pre-existing bug the AI flagged (leaving uncancelled
> works on system_freezable_wq if virtballoon_restore fails on the cold path):
> the AI is correct that this asynchronous work cancellation failure exists.
> 
> Since these are separate, pre-existing lifecycle bugs, would you prefer I
> roll fixes for the OOM notifier, shrinker/free page hinting, and work
> cancellations into a v2 of this patch, or submit them as a separate patch
> series to keep the stable backports clean?
> 

I think it would be best to have separate patches for each fix; Andrew, 
please correct me if you'd prefer one patch to address everything.

