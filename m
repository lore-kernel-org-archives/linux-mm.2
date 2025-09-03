Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D801DCA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EDCB8E0002; Wed,  3 Sep 2025 03:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E6E8E0001; Wed,  3 Sep 2025 03:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28CF98E0002; Wed,  3 Sep 2025 03:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 166CA8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:06:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E473F1A0481
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:06:30 +0000 (UTC)
X-FDA: 83847055740.27.96E1FB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id C05CF140008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:06:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DfaE8i4t;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756883188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y+D9yxWlv3zb+s719T1nYvszUA6hn5AyB9vVNM3BJTI=;
	b=gdctsHc+VWWNEsSxLEGl720lW9Vtoyhj9/EMjFCdFiqUklWdrqyxRBbnlGkHxJvZi/tziV
	WsVXlvNhcH8E/zPhKczyQjx0yMEy/NNZo+xnU4oEG3M/uAt2oJA4NnnEwUQHOGJTFl4rd/
	mt1ppnkDANGjqFBsuOlBBJ+jeQS8t/M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DfaE8i4t;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756883188; a=rsa-sha256;
	cv=none;
	b=yDTgILmEZdJL8xyWxWlwi51BH2NsBX2W+9KhLhdCIPPkpLoJWwGWNxn5X8/I/pf+zVjLoZ
	DtuMjRHW8fNNZekeSbYqiJ3oP85+Nbcx12rmKHm30bj9kUUhaeu6pU7tKQ+5RYM9EU6p0n
	EyPZVeQR7Zwd7KPOjE0LY8P+qS6QhZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756883188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=Y+D9yxWlv3zb+s719T1nYvszUA6hn5AyB9vVNM3BJTI=;
	b=DfaE8i4tGH4jQVnj2CmFIvjpt01Ip+LA+4eG3Bmbde+D4wmSb/NMJIXWWGfCZLXeC/m3Pg
	H+BxQ5D5ZP3P0MZBLGzbfVGW5Ae2J1UMNMxGr3QpkYG2lOm+AAIBml1pv8HtTHPI9z6V+j
	vRE8uBNqnU2I04zNMJA2rXja0GMmXxo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-2ObcxXSzOPy6k02jK2vScg-1; Wed, 03 Sep 2025 03:06:26 -0400
X-MC-Unique: 2ObcxXSzOPy6k02jK2vScg-1
X-Mimecast-MFC-AGG-ID: 2ObcxXSzOPy6k02jK2vScg_1756883185
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so11272695e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756883185; x=1757487985;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y+D9yxWlv3zb+s719T1nYvszUA6hn5AyB9vVNM3BJTI=;
        b=w1N0UIeWTf4YQDB5VBAaT9qVl6XecqyAIENrYrx/DUWMl2dmCbJYnXiXPt5rqkPnfm
         SJQguNNGTc5bAAsgW89U5Ow/+W1iUdKPd1lRSMsRnFF8W9tw4sFnwRmFeUMjaS3Wm//z
         TMcMSgCrMzFI964Ds331RSG2k4E0XORV9MeohM3hDr/BEXtMfahAMkTE2PkMf0+6GShx
         6TNz19RcQJBWTxi2Mfj2U/+QL1HKwXRTReWrZU2bC5luzeg5q1rUXQnk53NOCSWVoDj1
         /JPonoLZEvJyTSR8r4+vJ6RegEDt9sIxNBJ+TChcAcYchc5dONpPTguAutomhLrppA6i
         YwXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwPFtEtp/wjV2wRhNhxajpdedtEtgzY6wee6lno458osxa3yCnMgKefHHal7nHNToTAouRQNgPPw==@kvack.org
X-Gm-Message-State: AOJu0Ywi+T7s2eCOAx7PR57xZE/RU2H9hVy2RwfPFnvUT3EnkEvEgfUJ
	m9s+k8ZZIllhlhQrkVjBAAYB9uNGwLTlr+YYahZVmb7/5lei6zsrIx5h+j/9yVEetUqVcWfDaD4
	NGDo+qe1bmSfusonyQIx5MyAdJhmCPcfX0J+lkckvVmsdhMpYR+oM
X-Gm-Gg: ASbGnctG02uDLPRz+Nw5Kkn95/EZF1io7wvp7sNOdNJWmI4UMY8q3YfTYdfPcEXvf56
	6udGiD2TPJ/9IQEIj1UmIloGHGIoPZhOCmNvo5wS9OEaeAiECMAMuRSMPhC7PSejZPZW0KahVbA
	Raiyij7LJVbMN7IxQK3n1XxcXwvh2E9RlHxorIERKZptOyeC1tbQ6ULLyowI8xGgToJ++CLhXU9
	nO3T6DVQTHxJSoZLsgCLHyiEObdT0hRnazgMy1WOVpLAGPXAt0GQZhevVIZSZrvANpO9gRUNeHA
	n4uv6xdLvX6xf4yxgtDT6n1ienQGxKZ8U+xlClUZQM0Kv0fr/C7rkdU9bty6xk54N7epBBjSWg3
	vpzenXFCiegNJwa0WRbd1ZHGjKRUw42w9pcleqVNA56owSBp3Wzf715+Il2WdxW1Ln+k=
X-Received: by 2002:a05:600c:c04b:10b0:45b:98d4:5eb7 with SMTP id 5b1f17b1804b1-45b98d4615amr24361165e9.18.1756883185149;
        Wed, 03 Sep 2025 00:06:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpb9iES46gU1k0+ZA3uuV/BrR4IgrWcnRm7j0/2AFuzurkhW8jQEYi9qDtb+tVBa+08wt9oQ==
X-Received: by 2002:a05:600c:c04b:10b0:45b:98d4:5eb7 with SMTP id 5b1f17b1804b1-45b98d4615amr24360835e9.18.1756883184533;
        Wed, 03 Sep 2025 00:06:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d1319sm246236485e9.5.2025.09.03.00.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:06:24 -0700 (PDT)
Message-ID: <5d1bf8ef-5f30-4962-bbd3-d698c0e9b7fe@redhat.com>
Date: Wed, 3 Sep 2025 09:06:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-09-04
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4GtqVnAsaDXpqxMnOKfj_SkVxPEYxnmOnQz_ZoCimuA_1756883185
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C05CF140008
X-Stat-Signature: j33rkpf874qx8iijnx143dkc9srbetrt
X-Rspam-User: 
X-HE-Tag: 1756883188-700414
X-HE-Meta: U2FsdGVkX1/ung9kB/zaXnwwIRptiIVi0QgKwghXH9P32a8zVMPqxZpTbRfMKjXlVORpoXqXJtf18n3ImBb2VNUtv/8OyQvPRROCs9RsjVmcv3ZQ/IHsQ6G7Q5fYe4+iuiLcsSRH9VeWtSFsCt89us5MLyc5iJUbQvR0v4EmjEMpNrSkTKz+V5A3h1P0QEkxlDH5GDMRlpJEZ8f/anOt6g/kJ+uqXamFo2N5i7wHKZdLcH1AtsjrXC6hVQ6XKE6/G8f+D5jI1d5NnNIYntKjus6KivFBhiClqfFVkX6uQLVMsGBSVOq/yhxle6W9Z/1IcfBY8jtimdOzlFHnlFwimncND4BSMD2d4+on6f0qOAs2E3JguAtVb5FkWY9Whmjwbbgn+8fJndcbbvfUidi3Q7s+dXJs2pLcEF/ki84JfvxYWzUBrHLGWbgVnhmGBQxmj9jV7UE5b//xNzOFsydOiv0uvfag/O7G+OqdAzeqHcU5PscmCcGy7yAPXjE9z5/UnaXQWPwCvzmPIg2uCIh4ULd9CIEIoguWda3eu8bU7M/8q7PTgdXzb24w2r8pCFSTLKt0FqQPLl8c3Z4dzpycvtfc6OUy5GZYMejHGbbvHYUxuQcxS5Xlu9i3iAnz6aYBD8dMmWBjL5A3RMN5uNPdRYEgN3gXDXvnIP7wf0yGnBEDozRXTdCyWqdu39IB4ZdexE/PiUY7E8qMB3x3dFxP75d5RoR1zvFtDR8JrcoGWVac3njPZaHzXi4ODwdbdB1oG3QISrKLK/Js5sH6XbwynTxf1g9i7P5j06f8AFrW/E0y4ofpDQUuc6ve1siN5aSN3nRJSC53+MctZnI2cz8nMGlTmpEH/vFpge6BDDc08yAMhfjnwEnSdoQsMCGg45Nq5xNJG9X+Mpd6J3id6IQx+2S6Wo0HnS+jmvxQHWIQUVAX/Ms5E5HxMl+nMhyI8qOG1WJBgwm1Lb8BDMzDVGs
 17f62scO
 rwXCp27F5O2gB1sIHUaaRdVw0gO2elsfm1SexoXLUNTQK03jJJv65j+pek0NRa2o+6es/DXKnHBQI4NlLuoCyRTnvf7jA2GLjtqcBtTq3M2wbP/9NONhgMbi14uRYuqSzhlIo56ZyL5EZWBz08ZXNzcRiRGZExWqeDtBNf6IdtnfLFKNH36Q5oRwGLV740zNyM2F+iYU0NnwrnGAIvNZ3dl9nOU18K+cPsZMKAvWG/3TA9MJIu0CpVxFecDOynLDKtyEa1l1SDsQvdIYGFSBaquGaqIJNFK+Akx/S567ADexpwcMXtCMXh6hN8pM1LrLkM84DxxvuG0xk731Bu74+oukk19vVz1B3HC2SLuLssrZT4nx9QDRD/QJnsxo/CiJsjfzmZH7G2DcoWYgcpkI+PtkIcffGs8Dt3dHzwxg9DlzniuCzurU8zNManxcxR93e5e+G7A1t8FaLsjDsOxEZCMXswM5TY4yCma1gLuUEFzCkHbgJzukoajUDDJxdEGCMpvIWNhB8ceAdyLgwCs9k83AiXxQ49Eq6+aCQR1Ae5p0+ilaEvyk7jxcHCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-09-04 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

I suspect that we will continue our discussions around "stage 2" and 
whatever comes after that :)

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

--
Cheers,

David



