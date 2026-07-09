Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4A4C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 21:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE1B6B0005; Thu,  9 Jul 2026 17:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795A46B0088; Thu,  9 Jul 2026 17:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685E76B008A; Thu,  9 Jul 2026 17:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4194C6B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:57:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C84EF1C14C0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:57:08 +0000 (UTC)
X-FDA: 84970599336.25.FA67B3B
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 034D74000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:57:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aI3WAUK5;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783634227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AtZcCJL7SSO55KaeQpBRgHzud/kdG6WTG09Vy9G3lc=;
	b=IkJDYViutU1NWWcrARWvU5/bGsYFAnf8DZsaK1L7e3A7pkrV1ZkTesQCerqarUdpUU3m8q
	TMn+sn/l/21OSJxkexh1WfqBXmruLPsVwxsIQwsDg3iOf2pMP2OJNnfGBawArF09YQ7r0O
	vorICs8V46QWWte4IzQN8hkLNsflrqM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aI3WAUK5;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783634227;
	b=qvWOv9unQYtAwyuqyxCk6aEE8o/XVn09Gnps0Arhi1zU9HK9qY0qcrDncWz07ROMong4V/
	WkVC/4wPVapF4W5vUiMQLcq4nuax1m/+PM3qJWYvvbRKibK4KUmL74OWlWJDfbBSziLaX0
	zwLVXjDXA3sHqDRp+9RTfykfVNGIp9U=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8efef6533aaso2554146d6.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 14:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783634226; x=1784239026; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1AtZcCJL7SSO55KaeQpBRgHzud/kdG6WTG09Vy9G3lc=;
        b=aI3WAUK5ExW2TnViZyYaFy3RFR3fE2UOJQ0pJU+GgJG+Koh70+yo6889VKNZyQdx4i
         trGX9z5b0lFHWojyvbZLmLL5mBkDH/VsP9hfDue1K8QeK1ExAcPELZXVrhWe3ED1tcTt
         GBb3Ife9AJvwP88nE7BMYmQm7yXU0QEh7Q+wjAo+TFK+RQj1GNPJDEJWx44iuWmkz+k+
         bHX8uSjWmyuW7Zzk6rIP3opvWUYsfWkST9yT7IB6t991ZTyu8M0/vTvQ8TijccGu1FVR
         bGqRHQDYlKvAOLgbI890nWkkaHLxSrIgj8n2kezow6ZwiJWLTw0UXl3UTL+RYdITCNWg
         Q50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783634226; x=1784239026;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1AtZcCJL7SSO55KaeQpBRgHzud/kdG6WTG09Vy9G3lc=;
        b=EJ2ayySEzC3GYdUNzShwebaVf1EUvNsbn29JeUosW0zRNK0e9LpSsdSs/feB+T5hKo
         vwktjZ5OdDTv/bodTqedPDq+aiCDP4fW2A2E3SmV2pW8/YSk+VrW7/QztRprwpG8b3pB
         spM0kdJPylQJFJgeKcIvwxJ2MjdKCWFXreJn9ne8yEg69bOgbU+mx3ems0MXohnhacs+
         pv/5ecJ5ubRUGsd79+H9GxDUrZGUrAPQyYJkbXprayssLYcFM47vIMMysE07xGKD4u9X
         g7jC6mn66/rG0FDQI1vSojNLWjSynFhbcP3iTvgx36HMHWJBRT4f7P3KPQGwY+AK/tZj
         CAOg==
X-Gm-Message-State: AOJu0YwCqZ2NNT/9PfVdRiWuu9Eovk2/7xcREA+QOTeWtaLNrHin4+XL
	s5Up8Fjj/bdvwUa5l0NtbM1MoFTMhgw2RhVzuUKF3xYRmE4CA/LjZJmr+uD8XOWzhUM=
X-Gm-Gg: AfdE7cmzvpTJQZ5E4dkOI9W2DohhwpEFleDrg9C17s/c/vYCW658v1pl9bLXNNEejfo
	BVx1AKkQfkCMSy7/WtOkkYqD2Mdn32KidzURJdU1dnZuiB7haCldbH46YGRSHcSE3FDZNkXloc6
	/4RO8UOOBh8DpabQAndoITS2Kztik/We66c7Rx2QeG0VTPtaX9WvidDqrJD/UnB4QlfA4WMb3vQ
	NByi8y8t9MI7A+uTajtl9bdvBtvjOgjc25rmGvGpQ0tiw4zg55m5irTz1+2bBd1x3LPNnIKl6Nc
	FJ07li4yT+arFqGALzInIPaf8dqRogCk/rnZc/L8RvJ3daye7+BZVDK9+x9hCNBPAH5mIJcfmYE
	FTntDG8XMsYJhcfh0nbRL0okAjaN4V5VJNMSlp0zNJ4y0w2cfSabMuBP0QKxNkjnub+sxzoX3Cr
	P8llj2PMMCkk8L0bhLXF7ucxdUjCqBxLjTnx89L8kn8QeiNboJqyXnZtwxEa3xkIKTxu+i
X-Received: by 2002:a05:6214:2b83:b0:8e7:8d53:240f with SMTP id 6a1803df08f44-8fec2a4a020mr91687356d6.43.1783634226132;
        Thu, 09 Jul 2026 14:57:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd80fd82csm26977986d6.35.2026.07.09.14.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 14:57:05 -0700 (PDT)
Date: Thu, 9 Jul 2026 17:57:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str()
 and export string helpers
Message-ID: <alAZLBqgUEZliwk_@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-3-gourry@gourry.net>
 <bdf0ca14-eec4-43b6-93aa-310e77660d95@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdf0ca14-eec4-43b6-93aa-310e77660d95@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 034D74000B
X-Stat-Signature: kbzpc5mwe4tr8ianzznu3pqxn41r7s9f
X-HE-Tag: 1783634226-386747
X-HE-Meta: U2FsdGVkX18OLOxxNJb4R4YZCEPiu2ws4z/OdfyhUACeZEPPKI9WF2r9EZw1lwqXOFplieT9FPzpDS5DVe8xRd9xq9yyv5xO9NifFgM6eOLFG/tzxiPXS5Rsz+rshRJmSEFc3/GDoSppvCTFjFIum1R6Tj3/3AS/x8DtElYVg6I0Qwvlc8WFc13vTENrv8v8TSQXRrFJg6wQ1P167a0euMvo9rGjPkUaXa9HsBDA3tzHLMmhVDbJU3WAlV9/JA4wdYO/Y7UzaixRwCTEE8XMgS+sEVi7c3sOb5O5MCrK3Go1lxIPMoyQAP9FLDdMr24UaytzArZj5+vGrKwsn35ayWUSQPFcMO99fMkEis6wzWpE3Acvbks2UmroIyS+/7VRDNiF8RRc41ISjNb7OOr4J9HQ6cpCsQE1DiFiczCcjEhvjw9vc/EZJDGRBE468v5T4RKnZ1MxX3+bktmHWZRIAlCV7ZIpDoFfG0mubWqmNvE7FftAD8LVHUitJonfhtjVO9TE9cbgD6NEY3fLF0C0cJgU+Ry5Av2/tSdwx8IUGUnsuXbijb9Od46z/bxuUMeZuKZkxg3+e2VmVz/JDR7BQGVqsNqaTeg5U5tubaQdqaEjfXV7wa4hO30+vI+5TwHFzkTLWx+uSbSZOM2TBaNcPluJ8Lgs9759kut/a/HI+POSqe8lC+WkVX2EAtRBz9By8xckWyDriOiA5RZ/BLJfYukffkjcSbQ33JaK8GU+1zUP2OLqLksFO/a1n6ATRlpDgZTofKiIg9yTa2zbXmkZAvgFr8Kezye969ruVZY2kHJVLT+NHz3w524TR0h1HnJ6KvmdyXlqWsJnZPFrqoY/ukFkA25xNejSbDQLYSzYYAEbe5jkoHvIvkEHSKIZLqGHTmmOCpx7YilzuDDlayC6GIFjfdmajH2XC3yWN522rtme9YEOtdbu6ScbY1wk2ijyvR/QPCKVF7E5lvOOqw/
 qyGvPO20
 L2SYJj5q/0rgvhWFHzg1HoSmlxurR/9Bfk9LOr4hIKkZUSTETUoSL8XezyRfwxtpPn3nEFV5PsDJX5GQx8OVaWlJfKPFpCI/pTKEYNYk4463qe38EPpjHUp5rUJ8H8dmGX9BbrOf608+DgWRA5CsuZ0VsaSbvSoBCFpnC4+HprXDrHbjCzTM6SqKfGrYUteH3UHQuQnHxt6Uz5676HtfcsXTRFyhZJyMPSRGhuWfoqugw8yhUeM3NDCar152DB9huq0En7/ohXGixBOUq99y8AfuGhCaU3xGc9fAeH4EdnRwt1mkIExrfiRZ8QaOFOiZ8Va3NhN/SN8DdpPz91SsPEfKyXb2gCSVGNQvhxJbLAASfV47FJSbyJtfNZq8UnH6fVewekr3dZ24EB+2yNEbhuzit5dDYoKn20bEl0zyy0ASH5KBYcImD4bzoNczuAZkZUkCqOZZhEzfolmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 02:08:43PM -0700, Dave Jiang wrote:
> 
> >  extern int mhp_online_type_from_str(const char *str);
> > +const char *mhp_online_type_to_str(int online_type);
> 
> Does this need to also be 'extern'?
> 
> DJ
> 

General policy i've understood is: "No new extern"

We use the EXPORT_SYMBOL_* family instead now

~Gregory

