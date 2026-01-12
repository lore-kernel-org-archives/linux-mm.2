Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3E71CF45D7
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 23:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513F16B00BE; Mon, 12 Jan 2026 18:54:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB626B00BF; Mon, 12 Jan 2026 18:54:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD5C6B00C0; Mon, 12 Jan 2026 18:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26E5D6B00BE
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:54:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A717F5EBC1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:54:18 +0000 (UTC)
X-FDA: 84324968196.06.3AA81B9
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC21540005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:54:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=VykeTQHz;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768262056; a=rsa-sha256;
	cv=none;
	b=8DSx8JT7F9ReHDS8f2BZm/cFVck3N6nqoKlgxhjK38nAOW87SIyUmucafIkBqg/DmFp2OM
	NKUkUt4PdcdnU1BQuExT0kC+Mp5h35MpmedO/MH832mqbYVShWAVS7bOb3/3bE+1q0V3y7
	+6ymRFoAmoyDA8pAWCvfJ68SfJapb2U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=VykeTQHz;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768262056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbQpTPqvkNza84fX2uyalXQvb9OzER6/e1aJC0fiWDY=;
	b=beVdGsNOdU8xoigzVUmYC/Bb0OsPOWBd0NozX3VwNhGAokEh/z1jvsWxsS4+Rp0fCQD4OR
	M8dlL1W1wSOlGdyjPbKNP7IlswD1yT4SZplemQvnRaPWcwy9b2yzd5Up0CM1lF0pENsmYc
	4XXZH5ZNv0JDfvbF+ylZNmZdoUaI3GA=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4fc42188805so72745381cf.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768262056; x=1768866856; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vbQpTPqvkNza84fX2uyalXQvb9OzER6/e1aJC0fiWDY=;
        b=VykeTQHz2pMptrO15nBDQo3T4hMZgaJsvZgQ6NAr+W1FeKgi4u8MU8ReschY0rTmuM
         VbrruA6tiMzcobBYA0PRK15Tn9+G62ftjM6XRr8t4n5cZh8Wr+0hK0UYd70O2scBe2XB
         CZD0ITQQ3k00FJBZdTCqaKW3gZ2Z3UzJc89eR34TTeWS//sqXX19yDXYb5qErq3n1A1X
         bW2U3eptvGTpVWKLt0/cF45TBFDXke3N5jbf7mAHbcOwfAD9pTaHosSnnpxJBBKlwepi
         DcJW1EyBNo3sSVZ1pUdeIZe6Jub8PR/PQe4wJOunAZF+TBhK2TIWuUgMQp3AWKIS0Har
         VB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768262056; x=1768866856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbQpTPqvkNza84fX2uyalXQvb9OzER6/e1aJC0fiWDY=;
        b=YdPYo5SqbO0RxPi/XNSeqHlWP4dOHf+FEkTvsCNgFNfS5dci6e2luSIaEPRVJPQNAE
         3uzCsseoMBlbjCWVJe0BWIMFxFQkrcrZtFyHWa5b2age5iN5z6YaD+V/d2NJPJVMmKMO
         fdidrey9qQ3NOmMqomMHD1GkXzMrZkTxaLBEL+l3kY9pCqZH1gEYBwW9vFUYxeL64nBr
         Qf4Mc4BdsffcYoiIwikg9I39leajgS0kTGIABtGFnaMJr4DyLUhpltUcsI6Uuo02ZzEz
         ceYpXbcQPPk5aiddKYKzU2vSi805BsBkzfpJeu5ya9/ky+YODI43+ymDD4EVVKON1ohF
         riag==
X-Forwarded-Encrypted: i=1; AJvYcCUBfQIGGwOwxj5M0UavUcgS4DyM9bpHLUXDDuKfUwAO1wdv7B0u/ytmCKqa/rE75VmPW3BkFKRa9g==@kvack.org
X-Gm-Message-State: AOJu0YyjToD1zqf2LkjlWxB2BI6Kv0yKHnhSpSrPGfmelu8v6VPGN7wZ
	9vFJEswVftOjAVQNkLIzEw4CjI2yVScHVR9rHVcOymHWjfIq6p1J0lVdwPi07t2X8rE=
X-Gm-Gg: AY/fxX4ZqGV5E2SWwqLgtchkk8gxOfXa+VWx9++vCMNWxgibeiXq+bXaavSGH1vqlIT
	mSfoGS8D5rtKlKYuRPz7M0lvpxLQ9Fwp/5ghUNlE/lq9cYnPGEedwrbonZPD/Ia8z7EdVjKpa7V
	ZwG6SQTaG1JMM2Cdq7hncqx0+i1AUDpcmA4cS3M9OETpgu/X5kr8igYmhMC6JIbbVpZx/dANyFn
	kA1Ewn4/PMq6uFSkw539vX2c+jGxHDXhbPll9cWDEP6twkuLTYnIgv5cDSs3HZeZ0OF+bhr/ZvI
	APAYrYfczQmX9Pb46eNZ+JdqxhZzeYG8OC532YyNetUviPCvXpfcIS2ll/hzrbGWSFaP/ACOKuM
	sIZBuUylx26DGM9F7wvSqt0SuY6NM03kP9PnZfIvLRMyf+RMXWaJf6tLI1MKCPCUrdwah0NxBaV
	CbOBDxnKdnbXAwi+u1J20ssa0ZnPLPAYxMgdw9R+n2VhcXc1NQoReyrAuKVV+fisMR8z4=
X-Google-Smtp-Source: AGHT+IFqShnh4nFq4FI+txOqV94h9FNeJmPa4/JUWRJXzRBu2Yp6JXhvTMJ52+U7dVhw4CMApET5TA==
X-Received: by 2002:a05:622a:8d1b:b0:501:3b8c:7d63 with SMTP id d75a77b69052e-5013b8c8686mr4698571cf.26.1768262055766;
        Mon, 12 Jan 2026 15:54:15 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8e35dbfsm129011631cf.19.2026.01.12.15.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:54:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfRji-00000003fUm-0uFg;
	Mon, 12 Jan 2026 19:54:14 -0400
Date: Mon, 12 Jan 2026 19:54:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free
 callback
Message-ID: <20260112235414.GO745888@ziepe.ca>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <aWVsUu1RBKgn0VFH@lstrano-desk.jf.intel.com>
 <45A4E73B-F6C2-44B7-8C81-13E24ED12127@nvidia.com>
 <aWWCK0C23CUl9zEq@lstrano-desk.jf.intel.com>
 <fzpd6caij2l73jkdvvmlk4jxlrdbt5ozu4yladpsbdc4c4jvag@d72h42nfolgh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fzpd6caij2l73jkdvvmlk4jxlrdbt5ozu4yladpsbdc4c4jvag@d72h42nfolgh>
X-Stat-Signature: xzdqrhghdapxc7nu7qw77j3o9z96uw4h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC21540005
X-Rspam-User: 
X-HE-Tag: 1768262056-35370
X-HE-Meta: U2FsdGVkX1+9byvt+4cP8hnYMf6xu/H8XFyLsmufmIKvD77BPyQqlPL/KeiX0ok+GDB8u4jcdrCWJ6m/ZmgxEt2Xj3u6nms+qRD9Vgj3D0+3a01sizeySp+YOhwcpc/4hrV1zAWxa2H7tkByPXJy+36twCP5PSqgoLo0wE+fIUgg18X30d/94DB5EQIKe6+2XLFCmtTR2YjExVc0LvY+1jgFaAAWNguRrrBhZ5hfojzusn67yXvu1hc6JypYIF4v4fvSlNGvNXYFPZ0Q7lSMscUgxiX/almHnzfPInKU4UehJ/XHeOq2C9qSy2V+RM7ql1BQu+qWVDsxLgjQnUCPWHLluEJzX27BZm6XkYKnEjWqrvhl9X0SjUOkd8pDBskpoHmFFKOwWSV+B2mujsEkubIAEgOHc7bnacepOkZVFaniDzCufLiDiSS+Oqz+NbebOtihmhq6SK1TTyGTfm2Mo+reaEQnht2X0IkVAAxcs+Z66EsR7Khskb1qxwiSPkdhpqQfBAw6aOOLUnID+31n9ROYw2cg0w8GrDPoNTlkauJ7T1CDYmaESDvdEzj7d1WuspMjbFCNGBXOZGHhyy33C4HJypp85wdeW4M5C7yfT3ekUhYv4uIXt9w8EmrDwNe+IK+uJfp/pwxw4w7Eth9rCwm3ftGtFylDzRR0e03dQFFCvIMNE8GhLm+4NmnNd9bVudQD3RiWzkIMZhlEpPvVKBTgNp/6vt6VrWI4k8+HvRkguitPb8bk1u6v8ISt2dAARwuP2JA/DQa37v4Ak7ykXk1LUd7QYKYAHCmaw8tko13c3MnbRskjmmKojF8pP5A/CZId8TJv02oZn3elMcPXRy+pHHyHYnRtd5+AtXXIcfnk9duUXFZ/mmSzjeJusRxx2Nqv8eJyEvQFWQNL6ZImRJ8SpOoHrExUkgQUFTDpox7g+sdOskAHL6iR4s5zWmcI7gsRAFPnbVnqQ3sfAei
 OOM/0a32
 7Jgws6RJc0OLQcZUZBJXjhqsEqBvjZQyYQ+e1QyEgOplKjLoZmZ2jKP2gfuSQ8XpR+AXG9WZmFP55/3W8QbQnMvghl2DRkkfbv5aUg6izLXmNV9BuxofUTlFT3WbXONbPXMFrluTFd5tqrvEey7+gznqjElyeLdW9LDlkYdI9F7ZtsypDLyr2IrUXHOJ76qgq8kzh4a3og3A6uudBnATzTxyLdDQN0y0bpHdqaJWrOgKX9agyfklRiRLCVMr3T1fQGUKj1BUwWXot2B4sOFJ1pFhnualzkJHwvaEIpsGpiEN8GVFpHGMwQmIpAC+njxNxf8ffgY8+opcdh+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 10:44:27AM +1100, Alistair Popple wrote:

> Also drivers may have different strategies than just resetting everything back
> to small pages. For example the may choose to only ever allocate large folios
> making the whole clearing/resetting of folio fields superfluous.

+1

Jason

