Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F1C10D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BCE6B00A5; Mon, 30 Mar 2026 07:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC316B00A6; Mon, 30 Mar 2026 07:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB816B00A7; Mon, 30 Mar 2026 07:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64BF36B00A5
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:57:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 234B2160517
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:57:46 +0000 (UTC)
X-FDA: 84602580132.12.8E18A09
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8A8B5160004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:57:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fHA2SZlE;
	spf=pass (imf08.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871864; a=rsa-sha256;
	cv=none;
	b=fPsjOePcTzOYQCAbKX6EfUhE8IaqGOy/TOTGsvu0d+IzjzkCv1ZYZkpsFJYE84Zs/VFVoH
	RzzbubvhGnKon1gAVGhbIo77d4P+YWboIFhypan+5D5arUfKgllB5C7Lm8IwVUF5aNSvGA
	nUQVu7D7d0bC+WvizWRWnKrYjxN81aQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uh1xNXHxs6tIJU6BgE1ANOu6D34D8WcIS3q00d1KgWo=;
	b=LbqgiQPjURv7hTdfGwTSiH5ZQBeoGLnzuPK9aZEmj0J23WJLPcC3luF8iV3Za+FxA/Byqs
	+MTiskNdLHZstot7ayaeRt3kiBb8CNaJo+dkVnE0MiI3jaUInzty9zrt8MEGlXFrJbJQlb
	MNJTK0gb74ILDrKJwFcdG1WMxcjb/B4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fHA2SZlE;
	spf=pass (imf08.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774871861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uh1xNXHxs6tIJU6BgE1ANOu6D34D8WcIS3q00d1KgWo=;
	b=fHA2SZlEJpwHtJMZrUDRjEw3+hcmzJfc0ELv32euewBlJzlK883MtAIbApCNxsgCpjhhAA
	g4Re8rlTEazduaPTGE1IrinPI2BnXO8Y+s33rBBdxT3OP+jxSlc5F6MQrSaBXQ9WqWXrj3
	Q4PZGh8bPNQbhTR0G+Gqc9TT4zaOg1A=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-CMsuwXRsPJ2qrM0pftaCGA-1; Mon, 30 Mar 2026 07:57:40 -0400
X-MC-Unique: CMsuwXRsPJ2qrM0pftaCGA-1
X-Mimecast-MFC-AGG-ID: CMsuwXRsPJ2qrM0pftaCGA_1774871860
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b2454fc131so47763975ad.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871859; x=1775476659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uh1xNXHxs6tIJU6BgE1ANOu6D34D8WcIS3q00d1KgWo=;
        b=dX9VPahi3OWnusZLvxrFTax/Fkw3bhNy4IFGTEZHNA3BYqfSU1SgnWF9GEWKaJDfWU
         NEECMJNivz0///FAgwHBiYFh4o6NP4k8ayR3biDeXBoib0zFl8G/REra3qMINI56zi/l
         P/OitZ0k1UeGVbn1gl1WGHFj50RfIa3sdQJioj7G5YLAuav85DPspOGZRk5knUFbz77p
         D99JlfY2fVWaxwf54gNrL/L6iyNHVz5CWutGXBaagjWciNadUJJSL8RoS5vH5HE0guUu
         ASMBmRgjizlcB2EKVqbCVcCd1JL9LpSo2osUS5D122N3m1rUOjjP8CA5MvabZYtJjiWS
         5edQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVp+AQZECu+G6dS4ZZBXml7hstgy+XOUvbt2v/V5eY0KkoOMU3UaHrsc2b/IlzmeLV0Cf5z9jKpg==@kvack.org
X-Gm-Message-State: AOJu0YyDRYnTMr9fUPhVxGrrv0WPwixC0fi9gPwB9O/D4JYND+4LkXes
	3ygwMLFNdesx3TSlPo3ajouyVMAeaf+3rKTTghZq/xrGOtSQ9S3UBYNTLEEy0D96GQLemK3rxWJ
	AhOqW5xUrAZEnD+ThllFnHazhHPofvsJ/ejT1CKzzB1ZfDkqIAkB/Eikn02N8
X-Gm-Gg: ATEYQzztlAovsrWejTpGJIQ760nQKKKH6iP+Cjd/XlFc2W811OACoeKvdUFw7SfEgQO
	iFONIpPVNtCNKAoulstN2b5ufcAkoKUN/+fbOXZKJUOB767zmfcqq2GnZcQoQBVHuXDVTf2UbiN
	h6ML9gYnoCl76sIgQW03aBJ84iq2cYapCjqKW13RWur7bHoCQ8K2wvsWrkkMqV9WlgeP2z1xolL
	eqqzJEATouOzi0X0YHCGWsNPNtatj8QRqaEvWnemXtWrlbL1lqlRIdVOjANM5w88cEus3OTA7Db
	OPPrOX6YX24sgUZgR+Zi3AC/pEDNVYADJJRZTgIiIl2P2uqaYZPNY4t3MQ1vtU25ViqYvLn18VY
	kq4vSRHHia7XQfDl/Zg==
X-Received: by 2002:a17:902:e84d:b0:2b2:481b:de6c with SMTP id d9443c01a7336-2b2481be11emr68540945ad.10.1774871859280;
        Mon, 30 Mar 2026 04:57:39 -0700 (PDT)
X-Received: by 2002:a17:902:e84d:b0:2b2:481b:de6c with SMTP id d9443c01a7336-2b2481be11emr68540635ad.10.1774871858854;
        Mon, 30 Mar 2026 04:57:38 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765b9fsm94275665ad.43.2026.03.30.04.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:57:38 -0700 (PDT)
Date: Mon, 30 Mar 2026 19:57:35 +0800
From: Li Wang <liwang@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <acplL3cHWqp0-RMO@redhat.com>
References: <20260330053915.75442-1-liwang@redhat.com>
 <a5b7add7-0507-40c0-a324-81f243ffa261@kernel.org>
 <acok3JY66OcV0Qab@redhat.com>
 <acpMD8tRCJhgXHeg@redhat.com>
 <a1054c28-b574-4fcc-afe9-5e902209a22c@kernel.org>
 <acpgFlG4qj646hYp@redhat.com>
MIME-Version: 1.0
In-Reply-To: <acpgFlG4qj646hYp@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SMrY0CdARkG2njdS4vWBiaYpHxTRmEPw0pLNMOc6QA4_1774871860
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A8B5160004
X-Stat-Signature: h1o7qrc41qo6xjkpbxqn8u8m3hkmfabm
X-HE-Tag: 1774871862-775428
X-HE-Meta: U2FsdGVkX18y70wBQoFic61YL/bAv+U4tO8J40cebeKACf0Yg7Y+lZPvAvycgSv/UjV9Uy90uVUXVY7ZUrB+TTQdxoKKHytSGQwkLKznzeayrL6EOUS3ZdR7Z3E5jpF3V5z1+P4z9CmA16wo+cjBXkQlnbYWI0/5G+trup79kk+obnntRIQG1SGovg2TpAUQP91bsxPKX8aH71usYxUUVZRpJbm0KeMg8MbD5pVGFO6ydlVX+toWw+o8Axjjju838+NvGVOxQTbck5lMyaE6hUUXPlb50R3rk8sd+ihClP4wgIqAmzz5mNZGuVCm1eL9bmbyAOJZszAsHousuYPhYhjr4wQaFOc5aNxDiMrc6W0+DTHwln6bex5R8NwyN6ywLXwAjGujh5/irOmRBr8xp+tEZxY2jd9qh25mdxprHAka9pK7G1jNl+jiZ/MXje3+i7liCicl171oP7WqxO1oNw4/frm0aYL0dAOEib9bKief8kjAdoTdWBfZHu6Nau/StN8Jn30qExTWazbtbH79yt51MD20dbRkRX/JCumKBLXTxJB/7ieBMTQSLNWEayiWRuZuJnGGB2Yis9j7XtyGFSSv271x6pSO9dUCxTUug8qgogVC1rz9WRqN4VSVWCmHpu2Gpv76EF2fHaXspGjsYHUpRoMZq+EWMCKXQTskq4S8JFd93xVi3wUWWBtWtP53IFPAx7/53Vy9oZK4cv2al7v0aJTxwhy5PcLJXph814ELI8N2Tw2DcGb8k25Zwi5cZSy+7V/1TjZf4QKEc+RRucZS4lJ1cD0jSkfyZBSGV9QY8KIf6+u19eQOKiA4kjOCLETUh7DBOkUqGm3VDu3054R4/26/V6CcjHaTW0Nfxxr8h9zfE69RdadCxUO3DEqawchvaoMP6PXSHfCBBM+rCB/Q2F+t48xORqptLvmmdw0JT9fAVGf1Ey3xESpmk7XzD1LXwtsvbeViAXI+jnM
 gLhAmZRV
 +nkVELg2SHHVvA8bSTBQy+eKBpo2j6PKl9Z77DEiI6xgvAYBMNAWqGX9J60dducWY/P2uJ9/rs7OPrfAUF3HbNHVwMWHE+FuEZoinM0k4OzF14Ps2Jo2640AKA1vaZCVkW6aKjbIIa8lJlw3fh7Jt6Vga4CZjhYPykVYHgw3gXYx7U/TTtTg8mpdlYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 07:35:50PM +0800, Li Wang wrote:
> > >   int main(void)
> > >   {
> > >       ... 
> > >       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> > >       if (fd < 0)
> > >           ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
> > >   
> > >       if (get_dio_alignment(fd) < 0)
> > 
> > I would suggest that you query the alignment only once, and forward it
> > to the test.

Oh, I suddenly realized that you meant to store it in a local and forward
it through to check_dio_alignment() and run_test() as an explicit argument.  

Sure, I'm ok with that minor change:

int main(void)
{
        ...

        alignment = get_dio_alignment(fd);
        if (alignment < 0)
                ksft_exit_skip(...);

        run_test(fd, start_off, end_off, alignment);
}


-- 
Regards,
Li Wang


