Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 558A0CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F338E0033; Wed, 17 Sep 2025 11:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5358E0003; Wed, 17 Sep 2025 11:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3F48E0033; Wed, 17 Sep 2025 11:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64EF98E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:02:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1837F11A3B2
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:02:45 +0000 (UTC)
X-FDA: 83899059090.28.611D02F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 826B1100005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:02:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OsTEMvTE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758121362; a=rsa-sha256;
	cv=none;
	b=Mh5sdSEcgq7e73sIBnJRfHkk4/yOOSDp3isbLY43DuwOXLi9eAKXX3BGmgoUMX1z0eDszf
	my+Y9Z7BYrU9OeVDpucIoXmii6zb4Yv2CbcmOBXtS2wJ/dwe4IP65IDy0NPugCIH3zI06q
	3qHFLyDilSMEh8WW8h94jhmPrKAhkFI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OsTEMvTE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758121362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YYhCdI4Q9hUzoKgBgYNuwcWvhIZyQUxhaAtXakv2Ac0=;
	b=xMSUWI/YlsvXKJC2bhXtwLPltDe3Pl4pVI5mNxKAX3hNWFUPObj/jD3Dd2bGHcw18vM2jw
	0g/yG9kTrWebAyHuocGKu/vsZAtkUc/pHgV5pT8glG0TMQNMpVfBUgxbdsxuCK4wJ6BnsB
	cTC3lvHX10lWTejaxjzj1yEsyPOjPlg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758121361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=YYhCdI4Q9hUzoKgBgYNuwcWvhIZyQUxhaAtXakv2Ac0=;
	b=OsTEMvTEz9ll+++OtxsqfnMCov7ifZE28z0QTpJwmY/kY0OSoPxbJivacBeJEIpqCbBK1U
	LwAWA8PH6xH+bVva9vk3cYtVUB5W71a9jTbBXya3VgcaYXb2ZgcnKeNEB1Z0P/NICvGHVa
	dywkbPNFnHuynHrSeaNZztCvt5AqjTg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-kO4Jw_EjN02GmYBVDit1wA-1; Wed, 17 Sep 2025 11:02:38 -0400
X-MC-Unique: kO4Jw_EjN02GmYBVDit1wA-1
X-Mimecast-MFC-AGG-ID: kO4Jw_EjN02GmYBVDit1wA_1758121357
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45f2a1660fcso34387065e9.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758121357; x=1758726157;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YYhCdI4Q9hUzoKgBgYNuwcWvhIZyQUxhaAtXakv2Ac0=;
        b=h5WdhWEVIAgxEYaO0B/uzmhP7gLM/iYdwG1fXvfc4/xGJRd0+PDj583taJUMrWSs+S
         ee8Dl9eRGsThtfGhCcyAp8FpDv7t8KVDH9OHA1UoxLPyXYJyF+ugSvIQv9gUONZVZ+Ql
         jPK1JLPC/D5Uir+BuQBUS8E9dE+cG/lAEMLIHvQ49UTtBYrLP8hEKHBsVuheFpQJOzHs
         O7v8zfXyFCYaj2iKPD5LWTV+6QKzBfRNFFpna1uFfmvg0BUDpm4PsNEtx1AkQC01r3gs
         KNmPOZzmyBd7pBbNkavJkcpxIPgCidLext31LbQMsjDVaOLJyWlSOt5M58GOrnZzRJrd
         geMA==
X-Forwarded-Encrypted: i=1; AJvYcCWYozU0QLrNpCu2XjJlIQqgQlE8BJk2SDvd3YFE0WANVm/HbjQP0hPduCPjJyBWikIGD9xMlRul9A==@kvack.org
X-Gm-Message-State: AOJu0Ywtj/Sd8Llx+kPERthjq5Or+wKiGDuXoxVrf1K5+FkIQmA+Pknl
	stNOwFsZhFkCxm6PjU1iIzOLwVvJX28fwrDxYodWTYcpw7n4q+6mxsjSa+KeN7+7G01xpG3bY5S
	Uz8aHezNH26Wv95JXI9bM/ydu8qvvsgS4a9jfUuRkzqV6nk6vqACA
X-Gm-Gg: ASbGncu854Yp8cSaTTfDkJslZ0zWXn0QW5UmaVy9enAxeM1izZEf8GCyYte/hq1u22A
	SUJigalilPNoGo4X4hFoCpIvGxf7e+PWd85zei+RO/WeHG9AEbs1mZ45jEEd+k7rVt9CgvnJP3L
	7zcCZs49rlIrXmjn0vFHO109vJ2rp/IaShXkyxBlSo7+6N2+R9bHJPGb4hhshvfpnUGAl2mAq6y
	t54lZ/jWUPOLcsTIPITKj67dQfwBkluQc96MP9tr/YHbJ41OZhi95TvNZEnV47GMl7jvBJyAQij
	ZPBlguuGQlGidl4byDHn4VuslOU9LDLS8ippgUqDKYKEDGVghAPx9ILXk8VfsgvgQLE4KqFQTZu
	+AvqYUkKVg0TzWib7nVfBWbeOgDCLhtZaIgJVM6GVhdTBTElkFHtuBpHb+YZvCwOA
X-Received: by 2002:a05:600c:4f03:b0:45f:bef7:670b with SMTP id 5b1f17b1804b1-463699748c5mr11533395e9.3.1758121356168;
        Wed, 17 Sep 2025 08:02:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENQagQHTk2oT9ysMwgYVh+So5rsFAoYrcTyucKX1OXr6gl3RPWUZl+VDYfCpD1fI5KhTXxfw==
X-Received: by 2002:a05:600c:4f03:b0:45f:bef7:670b with SMTP id 5b1f17b1804b1-463699748c5mr11531555e9.3.1758121353883;
        Wed, 17 Sep 2025 08:02:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e98b439442sm15671180f8f.38.2025.09.17.08.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 08:02:32 -0700 (PDT)
Message-ID: <46bc189b-911e-4dfe-bafa-43ffb9200427@redhat.com>
Date: Wed, 17 Sep 2025 17:02:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-09-18
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p9x4n9DqmuG6ejjaW0KoPTuSf6w2i8cLCNu-Bug7fds_1758121357
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 826B1100005
X-Stat-Signature: x5nz5hnn7pcn13byfw5uzm19h91juatw
X-Rspam-User: 
X-HE-Tag: 1758121362-36920
X-HE-Meta: U2FsdGVkX1+v9Z57yctitXsZJl+px9bUsKayWS7N0YM5ytc4vBApb0iu3Ko5H8mj99oYv2px9NY9kqN7LC0bOHf1dhj5ZM+pXwNC6wgmScoPr9cIQgH/JNRJE56nHfLXueNXObM4E4nM38JDwbI6Rm24wd69c/+Y8wkIcvRAHj4+PHQQmVsnzBrC6zksc34HK/qdsrZrPLxYLjBtmCI0sKUHf8eTLPD/N14a65QIaF6mVfZCdolLc/joUhNXxNhARMwXLjIgqfVLKhHG0cGnhRnSOvMOlw0e4v0wZE57MI9M0lMFT2l+lR1fUjzuQ14dbXf9irTC/AOuyoSeuMmgyUvC1907GW38q8ZECZPjYqtYihgnD2/M0rYXttZirIAMRYZlQUMkDYzZ0/8+U1z7n4KLVAA/K5pnSTnEnCAYCOVmguGDgrOAa9oJqQNt7eJLd4cpXStA0cFeMzY3RjBPmVPkpe29hvQg+moTyW7lmqaH3AyQjWbSYoB02ezdmGAQHSQStrlZWnxSyfG03llkSdTGgJtFUTC/+hhVTwhtv6ichdnkzL/TAsL7Fe3H7AIOvcBZHfeC7VE7OML2xWfseJXEo3yA5SP+lxdhkuecDJAIK/3AT6fgY1DLJDS9Ro2xi0MG3Bd4i1eKLRbTZBtHpTIeBBRCSuiyQX6wzVCJ9niqOVxE7ddftj9SDKE4I+mFMjP0ZM9yhXKEhKxu0j8qKYcRBusFTGTOjfqOqhx5g+53jdtEQj0meunwJ84ULvWffupci0PV9EhO33Xq3FFBJ4ogJyHP/Yr7gy27V6pZz5xTXfTFRMf8q6XFUl/iaK1IFrApqjTFCYBpiJ8AIAAfhV7MCeH7rvxyeh4688CspZ67JTmWVZRotEIzfWCGxhuPgSKFz8PiLVqNvBNTqW+8sX+O2cpDMjj9uBtp8p57LotMVX8Ao9HzcbPzwN+qowKyjaiDm/wcTaco0zftzHc
 qoW+e7iI
 OSxIwM5fCPDfPIsVzLtwyAxu1QCjXJaSHq9I6dR3jpgTFtjXdCaWQUYxmkv5pLSyFwKpmfDw5yc3bxbR26tlOauy6cELn2UqqJ5fGyD5eI4hTG+VBf1mSuat+uz3TbMLTJ6LlOkw6JrW0+uxZ5agJ6OSdQ6b49Z/JNPgLPZt2kCUNiKq6uqYqqcj/gOB4PBa1JcwAX3iV+nLpiozc0GhZivrFJknTUHLBfrT3HDe2r55Qc20UM/h9TkP4UA1a2vG0fjeufg9CjQFEw/4THySn5H0H9Xfaw0Z9+DmK+QOU4vDSAk+JYbz+ii+WgLamCeX9MJtA6IddSPZHsVoG6bfS06Fs9LNvWm4N89Sz+DNk2I225D6e4ObFnijZ3VdYt9waUGnEY1Ptb1fWutq/A3E6K9aze2ATDHgdD6wWbAcC+u9g58F91FXYuUaXHPNnr3HZ1G1QpyyovJFOiVSkzuH2H015QMzlDTZkielFGuC4IeL4vzrv6ZrSvDQIupPfVg9t0a1cr1eqFFsYMSe2OfVXBD2wL8rjRRDiTAo20TbdrO06EcPPtIELEdc7Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-09-18 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

I suspect that we will talk about

(1) direct-map-removal support (folio_free callback making our life
     harder than it should :) )

(2) the future of preparedness tracking

(3) discussions around "stage 2" and whatever comes after that

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

--
Cheers,

David




