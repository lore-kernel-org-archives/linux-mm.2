Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACCDCC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68136B008C; Wed, 16 Sep 2026 09:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B402A6B0092; Wed, 16 Sep 2026 09:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30CF6B0093; Wed, 16 Sep 2026 09:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 813216B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:19:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CC32C0747
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:19:48 +0000 (UTC)
X-FDA: 85219682856.23.C883B75
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf08.hostedemail.com (Postfix) with ESMTP id F19E016000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:19:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DeddAq93;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DeddAq93;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789564786;
	b=5z6db2mvz1gv3HuZI1igX2DgN754JHAZHgNAPhUphBzQwr5cT5WKBXOex5hkKXj4mn+hBY
	/23O3djdLHQOCKQ0rt/Qp+/uBN3jVmkbqgxLdHDQfyubJLhMrmx7olq0g9FCcUrW1Qxtc5
	Gjw9Fh9P1cWKWXdRXcAAfvabSxYD2B0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789564786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/g2oyb1OwyLHE2WzpJBh/jQ1AsTk6Ezgm+5y3dxq+Tw=;
	b=Ji6iUUCL+YO39ki8Pp7Ie0U7bKxmDcZGtX7UwrOkvuWTpKUiQBvkvMbjhWBfmh9OEP7cxj
	VcYL7mmNoWg7JFsHdMvNV/PglKbV1q/B2ZJ2kuvmA8lhsyILKvCPsycXcZ6vJeR5R1DjhF
	V2Q6O+njz1y07IN7JQUqG/+s0yN1sXA=
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a99391ffb2so1718227a12.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789564784; x=1790169584; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/g2oyb1OwyLHE2WzpJBh/jQ1AsTk6Ezgm+5y3dxq+Tw=;
        b=DeddAq938+SAtdkxmaGwyjn0CY228VwweAqN0l5sr/GFp2SmTMReAYoqDUqZTR5c5A
         GrZPRWkFt2mFmGSwYeFzrvgrzdpu2s2kIA3586MR5U3CoPpFlcSuMsqdFqzo5SPlQvwB
         LEdV9Nqqmsa6QAvX4uUKM1hXn4x5nrhRMLGwLZhnMsIHmJN0f3RR7zhxbK8F+3IX/e10
         ncdwwhFS+htY0/Eh5KxKefEZQKDKAlkqfDhN1TVcU+89+BBE3Kv2toJ2YeG6a5USHmEo
         zLHO5/x6/dpZqLfnkb5iGEs9+f+iFMpkx6CIFdAsq5EKhmAApQDvV3RJNcKyl65YQ3Es
         bbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789564784; x=1790169584;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/g2oyb1OwyLHE2WzpJBh/jQ1AsTk6Ezgm+5y3dxq+Tw=;
        b=PvtgIx9fjbW4XtlzSscRCWTKCLVEFFBP1eifUgiFiuHg8MvZchlq3YV6rtD4fLqL46
         SwZaexU52mD8spZbTUqzaYkqeNdEpy13Z3mJnJXI3uXq7V88sveTM4f/pUx1dO7//wxY
         Wup+EQDUQSwHkjO8jsODz/LWMCLgRer28WG3DFUU+rxaU5O6vcv7Z7uxc9rDgW9ShucN
         0KQFi+94SsF8CVVark4YTkJOzjbHYoaSDyIaMnXmnHjlfx9wxRzHy+9LtuORx1J/irNk
         ImvzFdmibzPGqz15gP6Eu0qO3jXTrlswgu57AidspScnqerk0FqFSWLiVKv8Yuu8zOSL
         FPlQ==
X-Forwarded-Encrypted: i=1; AKwUvBwoiqaiBCGtSGKJhID9jfzDuT7VRjRDCBCYGa6r2zA2OBNOSW+dIY6bQXSH8u3aYZvDOnBQSD73Sg==@kvack.org
X-Gm-Message-State: AFuF++k9HUHGUmh2j7Asj9gNJV+JPAvMmmgsSd64U0/IQPCN78mZlVHZ
	aVTv8ZURBU9f8vnh5FWL/9EARcjEkeeEUI/NU0MBoeJAOyzWy4+fXDBXfmEfGaOM2oE=
X-Gm-Gg: AYBFou1+VAW9BOjtxXFDn0NeUHiAI7Wd5+yx62lo0Op2/PzSk4tw/8Z5q772OYQic1c
	R+1L1v99qdaosEYmbkXvMV4fYIZ9eSzEUxkBlqjEg1UzndkwOyHAsaY8gDDTlStgo+t64R7JcvR
	6IXlfz2qvozL0idcNTWPvey5/g+0wS5DrRTUY02gEg5ve2OGDx+zTfujE1eEIQ4oTNwY2+jjzm+
	9MKqpK61B1/lK+nNS/ukYy2rkQnoo9vAQJknpq+waan7n/GVAxpvlI43+VY2MGiZtf1MotHhVcZ
	phsXweDJeCGObg4BRukZbCHc4a2v6sg2gNjZclwSVLcf0RIm74W9JGZig5z64U0aLHPtuVrif9c
	+UNj4paYtOMPBcKNxTdvEc20C1n7fxRGb691zzS7/kmcLqrixV4/jT303xUEOIiDdL4W1gJVjeP
	ql91scmmNKl+9uEXWhFc9HK0zk58Hc8nVa+N+Od4PCxvkUEX9X1pZH9FG/heXG
X-Received: by 2002:a05:6402:1f12:b0:6a9:a5e7:f8d3 with SMTP id 4fb4d7f45d1cf-6aa223a42b5mr1916895a12.19.1789564784428;
        Wed, 16 Sep 2026 06:19:44 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa1cfe07e4sm1748298a12.2.2026.09.16.06.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 06:19:44 -0700 (PDT)
Date: Wed, 16 Sep 2026 15:19:43 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
	corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org,
	tony.luck@intel.com, jane.chu@oracle.com, jiaqiyan@google.com,
	Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org,
	jack@suse.cz, joel.granados@kernel.org, laoar.shao@gmail.com,
	lorenzo.stoakes@oracle.com, mclapinski@google.com,
	nao.horiguchi@gmail.com, osalvador@suse.de,
	rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
	shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aqqXbwglwYTyTuUG@tiehlicka>
References: <aqiIEkrc6aDBOqRg@hpe.com>
 <aqkCbgHmMGxI_GLG@tiehlicka>
 <aqmGd0GGUCkbZpkZ@hpe.com>
 <aqpYxAktjexhaMGc@tiehlicka>
 <ad36cd54-7319-4bb4-bf8f-9fcc7b009158@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad36cd54-7319-4bb4-bf8f-9fcc7b009158@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: F19E016000D
X-Stat-Signature: ra8dgyxh5jxwg4y714fszcowgc45z183
X-Rspamd-Server: rspam01
X-HE-Tag: 1789564785-128575
X-HE-Meta: U2FsdGVkX19pyWEU7cs2z5M+/IsYx3e3VaqH1coZFBzWlnlo3fcA2cVCXJ7HFyL4v4utY154hrwjywlShdhI+HMPUqNSyUeC0DXBMy6jaz6gjD9++aSmSy7p3gNHoEHUGKdvHimfckV1mX4x+I59GD4weHvJgzfW7u9ZStsty4tk2unnlZfS/OJgfobAzzCoLitWHsNeLyJCId/4W4/JqZ6hdUW1QxmzRhXLC0XagyFfh4IsEMOhvNGu6z6WDUXoYnphrGCLLZxyrJkeoWi4DzQxNvKArKTGh5IuyqQ1/smGaoFGj1YJl/1RKohfPj7KSf+vWoLHoustA7zmrw4jSSUEtJviPf43Zul3fE0nJEjawm/UnqhA4n2Tz4W7GKw+DHuyw818j/qe3whSCNA3jtQpHJexKU9OBvkdw6g9Lr4MTr45ogw6M92Q1OfzJ4dYgTvO2dRDN0jP+bIWFmEEBQOWTtyvfy3BRq2nmybrP3Ds/nBs4ahwktxgjPkfBIP5aneDu7zRgW0xriuy8p6v9TQ4IlxwAbADdMkDYvA456ZC9KqAwPvu+OdyM5YghRuZkA3LrCdqFPPIgKl66GrqtJ3ICIyOBwvExEUGBN5YtviB1mGMPdCjf5J+i7mGwRRylT/g1sS9Wl+LQzdrFWBla5sSfeG86gpfDTBe2FesFnWfyJ60GlLvjW1Rtj819Dxl5wQ2brWxWCbaN9wPve4SsyPI6LWFmr/gTELtHs8myt1WyZKRZsqqmqzbdGEC1QlcYf7Zr//C9R1p6pmp+NvBs8tyehb2OOTAdGFJ39zdGrBGBy7DuzPRHJ6w+yJV32PEvqy5nbkMyRslTtumTXmc4bXgX1rDt4bJ7qaoHxBYobF3Ujswn5iKVSMlir5bWDDDAK/03lgLyCMN73ChplC3l+TE8UrjmbFhopY4VoaMytAX+1Z0VYaHeulH4JBXZJpmeM9FLkbnN+inp0S55OL
 I9+Cxyw4
 LgDKtoqgi0vcw8/nnSYzu7Lh3dJveGjNmTTRMiyxgaDK7LuFnbik+iXkmRuJtovMj2M2r/ytYQMgWAqEQfbW1rAc6GuFr38gWgugdZEGPT1E8IziblxGS+K0InuMjG3Gd3GG1QK8Vcj+7ZN/UM3xfJ882sPFhLO09MCHg3VH1mshrTBbSbrxUoQGQBfFGgdfXkFuFZ8ujDlxAkVoPCZa3DOXtkpXy+WnaU1+V95vSPmx65qnIciS2MPSH5ZrGsqg7A4gWF/cevvofqsWE1YYtMbQg09tdDCy+wvHjadgDprdkLCXt3WlqJwNz82174Yd/mTdkUIHnt/5tFkAMeGctjV2xbS9bnDCgt+QsgGZW7BSNDf4rIF5aaJnyY7I94o0sgox7VFeLyyTdZReXbI/0O6roy5ER7+9yDaNT3usBAWk3EQiWR5WA4D2GBBOVS79zEFk9J4JGE2Dp0TezUkp2oIN8ZyNYDrjepy08
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 16-09-26 15:08:45, David Hildenbrand wrote:
> 
> > 
> > OK, so apparently there are some BIOSes which abuse this feature to
> > mimic a real HW poisoning. This doesn't change the overall picture
> > though
> 
> Is this really abusing? We know that a page is shaky and will likely go bad in
> the future, For now it is still accessible. Trying to migrate off that page stop
> using it right away sounds pretty logical to me.

Yes, no dispute on that. But we have HW poisoning for exactly that
purpose, no?

> Now, the weird thing is that for hugetlb we wants a different behavior (keep
> using the page and ignore the request to evacuate).

Exactly

-- 
Michal Hocko
SUSE Labs

