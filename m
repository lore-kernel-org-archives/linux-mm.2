Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71159CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F61B8E0127; Wed, 27 Aug 2025 03:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5888E0105; Wed, 27 Aug 2025 03:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794AE8E0127; Wed, 27 Aug 2025 03:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 663848E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:52:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDA0614049D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:52:33 +0000 (UTC)
X-FDA: 83821770186.08.513B059
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id F163940009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:52:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cUF6RM26;
	spf=pass (imf17.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756281152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N6SntE+UiHIpGFBxOP3k+c2SCeNJCrXgtm7HmQ15Vds=;
	b=TaF+aIyY3t77MD2Q7bmrqT87vx8K6S2zpx6mvSLZGmwVZWMGf3XhEKJQ6HoxjmbWMJf8fW
	Xc1Ik6LWny6XMvOE6CHeRje4txVwMjUMqEUTXZFgg0Km70CF+XlqhP5Y5vZhBd5pFDpnCF
	aQP83Y21NEqONDOUWPofHIcBjAx2pf4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cUF6RM26;
	spf=pass (imf17.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756281152; a=rsa-sha256;
	cv=none;
	b=SbdYgmGDHwE+HAwbXOyijcRvzIwCMlugTVtttz/qS3fBPhnbiaaOCclCzQyKMRYEaxNPK7
	XMFn23ioryxaVIn7pta6IiBduAjGUO8yCTQpzra0I3aa42NW6WY9PWAFv0ZX2Mh9fomnv/
	gjAznxXo17fJJ7S3V4nX0+pr1iCEl6s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756281151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N6SntE+UiHIpGFBxOP3k+c2SCeNJCrXgtm7HmQ15Vds=;
	b=cUF6RM26pCf3yJnPX+AhiBNz/s7LmM1F5pN7QLswrOXByDo4YOhs97bQZq6vvzzwoqCR7R
	UHN17J1eaU7ifBil2oapsK6lnTHifUij7E9DwJFqjwQJ1/j+oUkNWqBe69VWL8LaqtyHMK
	mRj4Hd9P68tUIPtQ9NcO9dA6kd4+r2Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-iZHGTYBHNge45eseCba7nw-1; Wed,
 27 Aug 2025 03:52:25 -0400
X-MC-Unique: iZHGTYBHNge45eseCba7nw-1
X-Mimecast-MFC-AGG-ID: iZHGTYBHNge45eseCba7nw_1756281140
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5354319560B4;
	Wed, 27 Aug 2025 07:52:20 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A23E180044F;
	Wed, 27 Aug 2025 07:52:13 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	shuah@kernel.org,
	linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chuhu@redhat.com
Subject: [PATCH 0/2] Fix va_high_addr_switch.sh test failure
Date: Wed, 27 Aug 2025 15:52:07 +0800
Message-ID: <20250827075209.2347015-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: F163940009
X-Rspam-User: 
X-Stat-Signature: jd638tbwouq7y1h3jm5zfobn955tsqu9
X-Rspamd-Server: rspam09
X-HE-Tag: 1756281151-264854
X-HE-Meta: U2FsdGVkX18yjgXVb/yo11DZO1O9AHkYs3Y8QElada7DnDkEv7NBOvgRXG9krmFaeVqfnGs76aZlvbbp/7lXv4mXCQFPEbQXafMUbdiVcHtlx+4hzAPWLcW4sdX/eOfuKVIHax+ryxbZLAEbzxa4/GstQdkLYKmHNb5lyTri06jnTikV7kI6Z8thNnwt7arM2pKGahqntk5oA2UoypQl9/0PhjVLt3zAZjvGsAXey1trBFbRyHJT4BYOJvBlJ+5VNeVIsTqv8YxCojg41cc0MfmMOebuo0Z9gc7W6QP3OnoOtdpTXVwzaEco1YzVI+Hvr9aXVD3q8QcRxoZMxK8o39ruzIhkq05Gr/LIv9ZmiftAv6X8bYRU1b+ycRqeQWUKuCzWxxnp2nn7yK2HAt2CW+HxSjucBt+DXVrW5p+TnBCS3GDvAdbZL6//e14fhlEifInKLBdc/3+pV2cCawnsjwnP+12UrAAiMxPXn4g76wMF/Uo5Bj2gS7DIJc0pnBnEsBDvejAIgmJ744kq/bIu98ijJkcpBTbWXDkhVYUMAcGR4PflisPZ9LSZtZ62IlC7xXJq9LN7AwoGAHv8KylYOgp4dTZ9JfPJtMFXrI/fnFjWRUX93tXkIFuFBSgfZYzg85GED4xmfKftuPoLk5oqJGGyon5jsNjcU1GL+lrL/9N4g6wUwmHIekuIwmeaIrpvVNCTWtiySeukCfEbcOprDwTCSxUeTBop/Zu+0Xr4cOkEewZyebqulG3eahzH75wHanQ2NG4NQm37xVTbDZimTgtcadsI7sYTXXErTCYXF9py7TjSmvQmgbiKzDHo/kJXSfE10Up6GlnlB4YfPVeR3WlZ3cRQbYgDc1wMcjr1sxHmR2scrTGZ2reIUrDSK+6AMMvVPvBbWinVpvxVnZQSajvdB82yERm+6ZBCHrEaip/EmEuto++IXbNYkCOEtgy9Zs62qUO3KHsDh5eAV5X
 eO3GKUVG
 3D4QrLaQOMD0+L4KRZnk4qYGssnKyC2ZI284Lpg25KEhdro4OZJaZZNIa1ZPi/9USDDQI8qBfRaSnx5frmZYRtx51t9RnYzXU9AmeDUj834mqS+3NDlUMfUoPWqjMUC+FUmB/WRWDkxjpYE9wGCDIH0APqUgaFbI0ayA0wEgAhxD4h9Zek7O1xnx2zBOmekNYen8sR7TGsd4nxcfei/iMgGZeoKj5sJdOhJf6AW/LpljRjqwSfP2Cqc21RGDWw5CAbsNNkBWwx8TMlYWtz3EYqChgfwz3UnSxmlAniSEIvjY6/dGviGe6HebUgGaiT6dkoYrEaHrfus3p2H1Fw6ugr3H85xlSX/SHiz5p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two patches fix the va_high_addr_switch.sh test failure on x86_64.
Patch 1 fixes the hugepages setup issue that nr_hugepages is reset too
early in run_vmtests.sh and break the later va_high_addr_switch testing.
Patch 2 fixes the test failure caused by the hint addr align method change
in hugetlb_get_unmapped_area().

Chunyu Hu (2):
  selftests/mm: fix hugepages cleanup too early
  selftests/mm: fix va_high_addr_switch.sh failure on x86_64

 tools/testing/selftests/mm/run_vmtests.sh        | 9 +++++++--
 tools/testing/selftests/mm/va_high_addr_switch.c | 4 ++--
 2 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.49.0


