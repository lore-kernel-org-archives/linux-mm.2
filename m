Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363E1EEC2AE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 23:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8818F6B0005; Mon, 23 Feb 2026 18:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B996B0089; Mon, 23 Feb 2026 18:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E1A6B008A; Mon, 23 Feb 2026 18:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D81B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:43:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7B045701F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:43:50 +0000 (UTC)
X-FDA: 84477351420.23.4F629E2
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 088BF40003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:43:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ntGrcAIh;
	spf=pass (imf12.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771890229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Nz0fZa7S09a21wJlX7cSiDYFAmJR+w6WbxCWC6v114=;
	b=Ftk4LvrI3H9+WBpTnYwHTqD14SSDc08dKAYa/h2CLqcKmBoLwNrDvIjK8NVjcXgOLaV4gS
	2c7S/m9T5CIMpRK2Osy0S/mZ7CjWRvRj8yK6srdvJVyp487UiWgbYjbLS6guc6GQbdviNH
	jvz5p5a4cbjcMDViNdE8BYALwOhIQbQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ntGrcAIh;
	spf=pass (imf12.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771890229; a=rsa-sha256;
	cv=none;
	b=g17FITrQchfRRSqvICGqLhLvA1ZgUme0xxyhhkUOP/XvS9Rvr7Z3VMW4SVVrJ1DmiV16Jy
	Fr02nuzafA9zR1Mbhjgw+LjX0kBGGleX65fUdya//Q2LwR3tdeMCnPdPzZyCs2JhiqqIZg
	aEg7Yxr2lUgI4awk3LW7xkrzohn+sFc=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2aad8123335so12945ad.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771890228; x=1772495028; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/Nz0fZa7S09a21wJlX7cSiDYFAmJR+w6WbxCWC6v114=;
        b=ntGrcAIhbeNSALoYZAbirY/UqmaohLANCcj8jX+X3nuUHZbRjryTWvx+Oq6tGbjqQU
         89CWiWFSGx5ekPspXnzQKsR90bi0DxcFIL9kgQrws15PJ1D1oW7UnX7pAR8h/S2ueBxB
         DFVa63O5D5XYrCALHb2DF9aW/zsOGWPm5f1ObeEoCwE3OwaS91tDIqv4oAWyGznG63qt
         mXK3xgpxl8GZCIEHE8dilOCDH9H9rcjCnXmI9z5q08vF1vQ1TWXOT5VPzKXYH3L7/4VT
         o/HgHCuBybvQC46BKnCGkHKKpJ1XNp25Sf81OD0Y2C6g3NI6Plvw8oNZZLXjQfMvz6vW
         2Xtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771890228; x=1772495028;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Nz0fZa7S09a21wJlX7cSiDYFAmJR+w6WbxCWC6v114=;
        b=RXcdVZ3iaGNcxFIiTn9fqBhyaRqdCLHw5f3jTv694tAI2UwdU9HW3sUy+dGMYbdmb/
         ntQHmyXT2Yt5yk57QIbH5QAhUkyjG3V3Hguw2NO/0n0HUT7R8cdt8o8avDvLUj/S91uX
         MjjHW/KinusZuLBtw9mBrH8d0TZNebvYWP/o+cZRDUXuu47fH52tmZr+hDBVo3V8OTg+
         oZskvR/AHLWqxbemNDygjoeoRzZ1ZXWO2Exc9iIonwrY2/iN96zV2EmzR4LdZepLKS4B
         yvd4CE0qwm24d0+zwA4qxVif1KF2f1UCs3Rx/exziGejcHsKsMZP/2M29IhoN5sFYVyb
         y27Q==
X-Forwarded-Encrypted: i=1; AJvYcCUoGnpj1MfMuRmeS+0kitwJrah2L5yRoRvamdth2X+nmJDN9bcuckXUJwOYtjgoFuSr81IJgu8SrA==@kvack.org
X-Gm-Message-State: AOJu0YxFN3K4PF9yGkiJThxRB9m9Bw0ZZWD6Y5Kt3TDdY8NOE2+z18yr
	rLFVcDAJyZpz6VbtcPKXJa03zJz1Y1qfdHEz4i+8ztpHhz/1BFGFDFp6XZZw8dlxvA==
X-Gm-Gg: ATEYQzzjCHVwnrnhwLMB0Vg13x9kh0jCDzdp7OY6MvO5S+sgK85b0IwHQNVE3z5tCW+
	X6dMbTPVwVH56kOKJsSj/WSowwpu3x/TbcfVMzZJivfaZ5hDnkoHp+8azW5QcfJplZrYJxOMUd/
	t4cnDi7PFz7IY3OQQXUj/3k+qVywNG0Tvi7LKPDf1j4oeangz1nKlldjSN5o9ywJnGOBExXM3Tl
	Vhs0Lz9/FhIieqsBmdX99qRiB/dnAU4REDR8JuSfGt5YQvnSLzQjrbh1NArnEwqf9j1rJOk03fE
	yThQfxNQPmtmTVCyfo6z26X07A61UVHCiagsu9o88H/2khTT1FCSMYtucVQsr85UfmmRtgioNwu
	sQuzF453Tj5PNRxbxj6pxTfLXrBrWEEcz6empZtJlQkS85+fQR8Mi2h+cYFw5cb6rLz1PlKXgG4
	bzjFVnuIe3A2OPtDkoYU8r9bsrFba1s0p5KaPXfrphynXoCAYP8S9XWV1H5/zHLw==
X-Received: by 2002:a17:903:41c3:b0:271:9873:80d9 with SMTP id d9443c01a7336-2ada3483c30mr271955ad.7.1771890226940;
        Mon, 23 Feb 2026 15:43:46 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e1c0sm90833575ad.45.2026.02.23.15.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 15:43:46 -0800 (PST)
Date: Mon, 23 Feb 2026 23:43:42 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <574e4wq43zm5tyfvvtjfvzqlhoyijcgvvk7gptghrx3ofq5ck2@l2q7xbmtibbq>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
 <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
 <CALzav=eXY=ZBshmpi9axt+_0SxaAm0Xbo7w==nCWJwKK3xcThw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=eXY=ZBshmpi9axt+_0SxaAm0Xbo7w==nCWJwKK3xcThw@mail.gmail.com>
X-Stat-Signature: 57p9axkoc7stre6ocnyeap49toxn6isr
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 088BF40003
X-HE-Tag: 1771890228-579482
X-HE-Meta: U2FsdGVkX19snc8UsqseiBJ8R3W+2Vdu9WJOSHkO3tf2jvQp/V3cBqmINP40w5y1uAs52cjNC6arD5O/rPjSgVBJkqoKTu+1afTZBGHrE5v+/dcQ9M64r8U5Pk1BasZ8tu/Tbc+i5tuo7i+oCIUPr86exXXC8+8GRfFS0fo8t7vPMhTmliuXaDVba3yfCU39dCiIX8vMWXWzZXbPQXO/vEfyX6v01ylqYrGWjzjAROUaETGM1Fxare3nOK4kbgUI48BuUhbjOBtFjTuqu3m9MwA7GeHYSuSQC2FM5Hy3Sk7Kz26uDMzHmiUTnhDBvBJVMaM7oHe6kCEkxKdJRZvCtqUDG0FVlOlFB0Z7MEG8pT1iq40ZRE//um72jJdsqfd1yJGu3nOcM12+gzgeaJO+nbIqSXJIkxgOY8Kt0R0zmvHjE91N3HtRdwpj0MbAoUFRSRReYiUwx1z/WUnaR2RdYW1H2q2pfXegnvJA0rTJbayS/dIC9SKs5iimBJEuFjjX4KD9E1clN/KBa1xH3ZQULgTJHwIYAixiBfosAqdmTb3mL5ghtbkykGlThu3No53VkLBY92NfKabBMK06WjhBwBSJCWHmRqSKaFlplxCcj3p/TlLzUIg8U9aotNY2zHnV/WkwF+XL/z2wyDIKoVmkXLENy77pJ4bpwBxJDhaH/IwgPQyEKXhMHPVdfyrZ2eXX5oGLc0pBlCAntGkmcIDiLZ2yiUru0E6WQQL75sNWQ6gCBGAU9D43bqOEuH1PqKKiO+nnBxXrc1nEwv6hUdBxxNQbqLhuo0VjGigTB4dG7qM/257752cdRtq9FGTZtetUloWuMo1PG9qDR0aBSEjZKmSA8/mc6Umt+PfqslZInHfDqbcwI1aLVEBvUMQsnN9J1AlCjBIAItHEA2LNB5q6SklylFnHy0s3QuhUdFR7fOIHFUPQJFxBc40a/N8boGGJA0b/MnK/XnkAuMhYBs2
 Y3+0ymF7
 Yp3g87+VokWvte+fRLMEcvmISTYjrq6ufrmh5Ke2NkyTWNkaNve0/2SoNQdk+UY7EiAgSZfgXw3RuDHGI+wFIa7PJIVPiGSEARv8+qhIU3wy2dI8tHUEdUjyu12FgrK4C5jJ3CAenW13oobb9AOkO0ugi1OoJYZiD2Rx4snsf0tr5yp5tJKKxhyRuwEOXqfb3o/0nlmGcUbJ1mP++dmnc3CV0FFL8qDO41VonSWNuR3V7ZV8p3R4rSQeyRl+XbpMO+WoeyXLq8oAin5fQjnAJbO8pO65IrFvdsmQ6u4oSoJFA61WA+z2W9P4bP+TVNlUe8FvCnNN0PbWaAn7trxvStyjkiAGwlSINc3s1c0SD3K6Bx4o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 03:08:19PM -0800, David Matlack wrote:
>On Mon, Feb 23, 2026 at 2:04 PM Samiullah Khawaja <skhawaja@google.com> wrote:
>> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
>
>> >Drivers can notify the PCI subsystem whenever a device is preserved and
>> >unpreserved with the following APIs:
>> >
>> >  pci_liveupdate_outgoing_preserve(pci_dev)
>> >  pci_liveupdate_outgoing_unpreserve(pci_dev)
>>
>> nit: Preserve and Unpreserve can only be done from outgoing kernel, maybe
>> remove the "outgoing" from the function name.
>
>That's reasonable, I can make that change in v3.

I should have added it earlier, but the same applies to the
pci_liveupdate_incoming_finish() as it can only be done with incoming
kernel. Maybe we can remove incoming from it also for consistency?
>
>> >+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
>> >+{
>> >+      struct pci_dev *dev = NULL;
>> >+      int max_nr_devices = 0;
>> >+      struct pci_ser *ser;
>> >+      unsigned long size;
>> >+
>> >+      for_each_pci_dev(dev)
>> >+              max_nr_devices++;
>>
>> This will not work for SRIOV as new devices will be registered when
>> sriov is enabled and the max will increase. As we are not handling VFs
>> with this patch series, this can be fine?
>
>That's right. Since this series does not support VFs
>(pci_liveupdate_outgoing_preserve(VF) will return -EINVAL), I dropped
>the logic from v1 that included the maximum possible number of VFs in
>max_nr_devices.
>
>Once we add support for preserving VFs, we can update this logic.
>
>Another way that pci_liveupdate_outgoing_preserve() could fail due to
>running out of room is if hot-plugged devices are preserved. But I
>don't think that's an important problem to solve right now.

