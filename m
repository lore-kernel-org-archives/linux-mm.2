Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A9FCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 00:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34DE28E0005; Sun, 21 Sep 2025 20:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325328E0001; Sun, 21 Sep 2025 20:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AF38E0005; Sun, 21 Sep 2025 20:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13E418E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 20:28:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81E56140456
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 00:28:39 +0000 (UTC)
X-FDA: 83915000358.10.C808662
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 85C0540002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 00:28:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XL7uuYla;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758500917;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iOnT5FR4XcNpcoZc3MvQE0LLgJ5N8o3aa+ZW0r8SjE=;
	b=bPA2Sw4ZQKrFAR579J6DsN8+Jq5EfAW66uL4tKtiT7LI6dMoRKaHieZoXYoJidUIR8SMQE
	nAqjtAxxSLTn6bAh5rzLZ26Dn8F3f+Qp6g/6Rb2osmgd9Z8Tc8HxUlbkGTp/KxgZv1hSHc
	o9gB+XvrMENPXWWK69bnjnmfUeJ39xM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XL7uuYla;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758500917; a=rsa-sha256;
	cv=none;
	b=EVgX4a6sFXqVKlGzNLyfB+VTyVoSqnsUoODQFfUbp9QWR1U0Tkbk8MXrTLDMiP4lFmq7cc
	tPz0YOIDSRw0U/RaoZYYMhFSJyl/VsCj5N0hi0IC8yAOdgx4Aazmxdto3agPjtvIgG8uX9
	DZMcwdiYHOLay/R53wSVmy+MYYVUGiQ=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b2b4318a202so87539666b.1
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 17:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758500916; x=1759105716; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9iOnT5FR4XcNpcoZc3MvQE0LLgJ5N8o3aa+ZW0r8SjE=;
        b=XL7uuYlaWbcNi6suhIrkJiFiowGsRFzgTk9RI2F5dts0tXLf/l2ekIECg5DTzg+42I
         bmvrQdod+iSXJykm4Kw9klxd9mlcVMKnMqh/oBduwdzSce2e2nQxBa/fuUAaMyHh2t3X
         4G54JgVi1GimvRTQb+zICFQTTceaT4jVqUo8Eiwa4ZYZVnnr5QunG+jWLZoW4piZTOaW
         tT7xKuix6upIg82sDCncw7EY05pyYkVDZSihWv1f46U8Kx8s3RcF8VmThOeorNC+MQSD
         pxIX2FhY3j/I4XejREo/AgEUF6fKC/sn4SP9rHQYkyyFRKXm6R+AqJX6fiuREb2DEdq3
         nkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758500916; x=1759105716;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9iOnT5FR4XcNpcoZc3MvQE0LLgJ5N8o3aa+ZW0r8SjE=;
        b=jiJkSm49U+EvUMRGxAnP3phLHZNwx5UFSlQdNJ+AzLZU4ZYVUIjGeNJqX9SdrGfdbN
         YH0ToBN+gs4Puh8Z3ULkcRHsaNhvwKLtQWq3T68ZQ9vHJ2ZGO9kWtFFkSJUPLe/5KkLc
         efqX4ts6qQOh1vNjb9qtEyBdlcELVDLARKGaIHir5sTRQvNMTq4QrwDSdcHo3g2EKeLG
         Uns0G7HRPWkHHz+002W2h9UfmslmfGSMCSR2SQ0zwYPz0qVk8kZciUKS7OY4kbWNsAaA
         RKtY3+Ike6eYxSpJ0ryB8DXKA+ZSRj1bspf/a+szJt4hMpAP2hR68CzWhDtnTmQWusUM
         dRDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSL1NB+E4Vm8dPTFA0qBUyVbSGIsrH8AHMUBf+LLl6ew8LuKSB4mD7aoFmjsN9KETb34G0HRVzaA==@kvack.org
X-Gm-Message-State: AOJu0Yx3yvWpj9qbtg9OP2DVyWO5/yfwekB2jEfLbWAcic0XIDV8BHNT
	usS9ja7dTyuwZjz9w9kJus/JmBcgiZi4myMQKOSQPThPTuhpnv5EDWkJ
X-Gm-Gg: ASbGncv8kmERh6gbtz0DjgXtNcGq9FgLD+FTV+H9Q7XkwS6hizeqg5f+f4ABWFdnC9L
	cLVzIYT1h3jnAbjKWTlmuN1rIRtoAb1qsLYRWSHEn3yLyqbijn6XKiXSBfkOBVnpszmnQ1+1vtD
	IAnk09Gxy3t0Im2rLFIZhF5RGm/MxE0xWXUozW7/V3DhlhG+6AnjKPKtxAycoBTXgBWJmIUr+MI
	XZyiKmH8NsnKXgBVL1T6sYx/ST/daGxFsL6nBehwV/b/Rym2lm62DXkJGayj3RM9bMO9hDBiX4Q
	nSN0Wrq4tN9n+N1hRDdBcdXTw69NUjipGLOoYOsyFCJvRIT0vSP0UzzEenGnbmGAKLuZnYPxaHA
	VX+ZSPnu7QXS2wcDJipUl9g==
X-Google-Smtp-Source: AGHT+IHsXPTF0BdSmW2+RvJ3xD4P4W52sUaj8gysQJt2NBI0+441DdBmcBTdZ6P3WMKdVd3MqLgkow==
X-Received: by 2002:a17:906:1719:b0:b2a:10a3:7112 with SMTP id a640c23a62f3a-b2a10c21449mr344268166b.24.1758500915578;
        Sun, 21 Sep 2025 17:28:35 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2890e047b7sm435957166b.5.2025.09.21.17.28.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 21 Sep 2025 17:28:35 -0700 (PDT)
Date: Mon, 22 Sep 2025 00:28:34 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, xu.xin16@zte.com.cn, linux-mm@kvack.org,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
Message-ID: <20250922002834.vz6ntj36e75ehkyp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250920115233.81851-1-sj@kernel.org>
 <c4df52c1-f873-4e2c-ae7d-f66bcf6e2fbb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4df52c1-f873-4e2c-ae7d-f66bcf6e2fbb@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 85C0540002
X-Rspamd-Server: rspam05
X-Stat-Signature: iw41rgouwyzywrpnjnium6yjzyz9wz8c
X-Rspam-User: 
X-HE-Tag: 1758500917-923721
X-HE-Meta: U2FsdGVkX1+J9zFUN+HYbh9B1OSu7iE7NoTfhXJ2IJiAwEp2agJ9VRdnriBGryztiBzNRlot9ro8zPmOCRAoJB/I10dfl6QPdBTzCH/1hhWQ0RJvA+enLOZOfRD4SWQ4RTsvNH3cvljIPj0Xv37IYMFiDEvoMCeRg/4QeINsNK5DeHj9S872tDXTz21Li0luiHta3g3Q8XfEPRtDmfcoidNp9+d/sGLjDRgXNTl613A33wBlNeY9haZ+x7qRk6rtJckTdRZJFHZyZJvvhojjFsEwpCCBZhYcP6F4zxerurlGwL5GYaYgeHOUvWF3Sm9bCcvKhzSIYoTjaHXjjTLS/IEjxZzyQwYHsPBvRkBvOjv8ufsPn2igwMba+zHnKqKD7p69ADpX3Tzk41dC6dFFgc8X13V2q9/cd3CVU6Ic5U37ZANMSehRcdDlulQHlNGQucK4lz7leHNelvjZ1xKlUXX6L7App5HUP+a43QVIe4VcrpCBc1JAXs6f6cI9KCgB7Rh4gTuODNc9xjVIK3o/0AaI/HAaPDGDXePiCkyFn4pugCIvx5928O2JIuNass0MoRBtD9F3ZALkIVwrxc8H2B+ey29lUFZqxDPyRd01m++vTL6jTmJfjfjlSBiRzdc/dEJwgxCOxbuFhgQmI2AydeUJ7MGxuVSQWvHHF0x9B8r+A8JBx/1gnUUXC9zneGOM8kzgn5KGGbpBqYQuNVdclH9BKt0/x7b4LsP1YBkhcb6KQrhuhbjwm/00vK75yDSMjtsoPmsnXmSriMB7UTC3Tw8zaDsh+Y8+nhoKFL228FyxLZ0Ef+Xf0GigOYw+tryWCm6x2hbhcJkorrCPRPiRBeoZTHQvBKiaXtImpaZndn45cHw2APJBs+bj63Sx6m12zY00A+hy4LY650QSEKqQEGJsOQph+1Qa+G6C7A9qGCJq3pB1WTVuutQq6ok2mORZc+EAjEA95ZB8z+uZrNI
 xbAFJLHZ
 +1xuWyNR0h33UdbNDoeCgwsTQoQ7sApb/oM53kAna01ZbahZmKALvle2aHwJPzssBVP2gbJQfCdoc9iwfVptoc95dMNv1UPrY8aURbo3jVi8Ug1WBwCP0wg0i7+61tc/EfDzvs9NWJ7sR7dYotW4ZSnX1CIQ5gtaaq0rfZPwtYDRfi2iytjTAuQsRtiqlIHN9Kpq4yo0cbHrN+/4xqmoeletXFF/qbpifsFtOfnqToav+NAr4GYp4BCI9C+2JdPE0njNUEzqGVZNtweNIPdp3N15QgHjYQKDIWbYtQZsHQYJ4wYD0tVzVMPJwQ9TbPViwJOoJKvtYpwMJltoEell18hXkmdi8Y9fWA+4XCaeiVkRF5QSbiEEIw/XYGEP5MK6JMdSbb5v2Q+ChusXVUeRVgdAzL3Dy3luWm5CTlcjeMURGjYGef5wjxoLYEhwEfjFRIawEMPPAV1gqo6V+rG1XAv705F2Fs5uIThDg5Ru2XIvwbdgQgS1F5ZaD7ViYE3a6VF4kMGUflpy0wPwWmm+hYeMKuub78BPGowXk8eXyjZR4aOEdXxiOU22CxMYu3c2S6+6lvRG/jldAtjRu7WJzrOWgBhmwylQnHg0YjIVpFiaTmQmmuwAitb1F4C+UbiBWkMIj9uXh4C67LZX6h6hXm///Qgsyiu7790sVptfkf1EVdQ8+cOX2wHZdF2BLMe22peL6yRyWo9SBd4dP2kT9Pa2tRAl2V1VaSq/xtO8nor4tgHBDDg1itnwOVm4wf5NxreFwhVJjippUFUi/QpBAlZUvTb/paBAse3uCOtzxVltogfDPt2a8bSQCIi35tbK0c3cQ24qpkgSOVEcLwubqgbmfA/bwrBGBdai1LGmqD4GNjApbtxjdHH7yykqd/uRdUt3vaOhPkKvBhxqoeTnrqfTx7dh7hn2OGXqwh7e3GWcReb/5NTjWk9O2P4tctRQoqGcw8KrmxsUjiaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 12:07:32AM +0800, Lance Yang wrote:
>Good catch!
>
>Looking at the crash report, this seems like a use-after-free bug
>introduced in khugepaged_scan_mm_slot(). See below please.
>
>On 2025/9/20 19:52, SeongJae Park wrote:
>> Hello,
>> 
>> On Fri, 19 Sep 2025 07:12:44 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>> 
>> > Current code is not correct to get struct khugepaged_mm_slot by
>> > mm_slot_entry() without checking mm_slot is !NULL. There is no problem
>> > reported since slot is the first element of struct khugepaged_mm_slot.
>> > 
>> > While struct khugepaged_mm_slot is just a wrapper of struct mm_slot,
>> > there is no need to define it.
>> > 
>> > Remove the definition of struct khugepaged_mm_slot, so there is not
>> > chance to miss use mm_slot_entry().
>> > 
>> > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > Cc: Lance Yang <lance.yang@linux.dev>
>> > Cc: David Hildenbrand <david@redhat.com>
>> > Cc: Dev Jain <dev.jain@arm.com>
>> > Cc: Kiryl Shutsemau <kirill@shutemov.name>
>> > Cc: xu.xin16@zte.com.cn
>> > ---
>> >   mm/khugepaged.c | 57 ++++++++++++++++++-------------------------------
>> >   1 file changed, 21 insertions(+), 36 deletions(-)
>> > 
>> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > index e019ea2cbab0..88ea92c64bf0 100644
>> > --- a/mm/khugepaged.c
>> > +++ b/mm/khugepaged.c
>> [...]
>> > @@ -2376,7 +2365,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> >   	__acquires(&khugepaged_mm_lock)
>> >   {
>> >   	struct vma_iterator vmi;
>> > -	struct khugepaged_mm_slot *mm_slot;
>> >   	struct mm_slot *slot;
>> >   	struct mm_struct *mm;
>> >   	struct vm_area_struct *vma;
>> > @@ -2387,14 +2375,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> >   	*result = SCAN_FAIL;
>> >   	if (khugepaged_scan.mm_slot) {
>> > -		mm_slot = khugepaged_scan.mm_slot;
>> > -		slot = &mm_slot->slot;
>> > +		slot = khugepaged_scan.mm_slot;
>> >   	} else {
>> >   		slot = list_first_entry(&khugepaged_scan.mm_head,
>> >   				     struct mm_slot, mm_node);
>> > -		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>> >   		khugepaged_scan.address = 0;
>> > -		khugepaged_scan.mm_slot = mm_slot;
>> > +		khugepaged_scan.mm_slot = slot;
>> >   	}
>> >   	spin_unlock(&khugepaged_mm_lock);
>> > @@ -2492,7 +2478,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> >   breakouterloop_mmap_lock:
>> >   	spin_lock(&khugepaged_mm_lock);
>> > -	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
>> > +	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
>> >   	/*
>> >   	 * Release the current mm_slot if this mm is about to die, or
>> >   	 * if we scanned all vmas of this mm.
>> > @@ -2505,15 +2491,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> >   		 */
>> >   		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
>> >   			slot = list_next_entry(slot, mm_node);
>
>In the original code, we used two distinct local variables.
>
>1) struct khugepaged_mm_slot *mm_slot:
>mm_slot consistently pointed to the item being processed in the
>current call.
>
>2) struct mm_slot *slot:
>The local slot pointer could be advanced to the next item.
>
>> > -			khugepaged_scan.mm_slot =
>> > -				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>> > +			khugepaged_scan.mm_slot = slot;
>> >   			khugepaged_scan.address = 0;
>> >   		} else {
>> >   			khugepaged_scan.mm_slot = NULL;
>> >   			khugepaged_full_scans++;
>> >   		}
>> > -		collect_mm_slot(mm_slot);
>
>At the end, collect_mm_slot(mm_slot) correctly operated on the
>original item for that scan.
>
>> > +		collect_mm_slot(slot);
>
>However, this patch merges these two into a single slot variable.
>
>When slot = list_next_entry(slot, mm_node); is called, the slot
>pointer is updated to the next item.
>

Oops, you are right. Thanks for spotting it.

@SeongJae, would you mind applying this change and try again?

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d28d1116e83f..fb517b5ad277 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2508,8 +2508,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
                 * mm_slot not pointing to the exiting mm.
                 */
                if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
-                       slot = list_next_entry(slot, mm_node);
-                       khugepaged_scan.mm_slot = slot;
+                       khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
                        khugepaged_scan.address = 0;
                } else {
                        khugepaged_scan.mm_slot = NULL;

>Passing this new pointer to collect_mm_slot() then causes a
>use-after-free on the following iteration, IIUC.
>
>Cheers,
>Lance

-- 
Wei Yang
Help you, Help me

