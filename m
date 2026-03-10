Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 120A8FD2D9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7449C6B00C6; Tue, 10 Mar 2026 10:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEBF6B00CE; Tue, 10 Mar 2026 10:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614DB6B00D1; Tue, 10 Mar 2026 10:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5362B6B00C6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:09:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 125C2B68C8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:09:20 +0000 (UTC)
X-FDA: 84530335680.30.0154D73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id D7BEAC0012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:09:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gKDR15+f;
	spf=pass (imf10.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773151758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGaoul3yuJqynOQk2erX7A5QGgPE1g4T37mrg0FVrlk=;
	b=dsM3tECiW12iQaD2XXJsCFn8LNOGzvLfQ8t/5TvQKGKy+qikNh/7W5ar2nllwTXJLtvrMK
	KIEQ3fDhnH/tfLdf0PmACco3K33clqC3EgkSLP2XhLecx4SDaVJVN22W8UAKDna4HCg/QK
	wpVaysrV5Z+gOGG8tVoqoq+Ny58mxcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773151758; a=rsa-sha256;
	cv=none;
	b=BHh3uB5r1Dv2uqdFOmh7F15xVF/edDNNwACtlFPC+OotJ0ndk6e64LGVMortJQLRPSzhNW
	eFTr4jF+ejJixqZ7WbI5VYq9iqt4S1YEKZrGHYiPKf6rG7F8RqUmuDi5VresnX+eW2uweh
	7DY7KKlqSSmqAZn7NcSzbWnohyyGDiM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gKDR15+f;
	spf=pass (imf10.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773151757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UGaoul3yuJqynOQk2erX7A5QGgPE1g4T37mrg0FVrlk=;
	b=gKDR15+fHrjYshB5L1wBz1hE5D8bLTnXL+rNAt1mh9sr08VuUm1BUSKZ1egFicw55VJjLR
	6zi9B1iXOvn/Xt12funnUW7fT/Wrw7aIjLwzyDTWmcwXHEnkro85zxvGw/TkbdtJOyCvEO
	G4CHNlRiSZJxkEBebQ29ne7TiG2BXzo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-m5o7F6riMXeKGzQ5SQSztg-1; Tue,
 10 Mar 2026 10:09:13 -0400
X-MC-Unique: m5o7F6riMXeKGzQ5SQSztg-1
X-Mimecast-MFC-AGG-ID: m5o7F6riMXeKGzQ5SQSztg_1773151747
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D3F51956095;
	Tue, 10 Mar 2026 14:09:07 +0000 (UTC)
Received: from [10.22.89.94] (unknown [10.22.89.94])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD8D61800576;
	Tue, 10 Mar 2026 14:09:04 +0000 (UTC)
Message-ID: <ee563439-9ba2-4f0e-8309-fcabc527ec58@redhat.com>
Date: Tue, 10 Mar 2026 10:09:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftest: memcg: Skp memcg_sock test if address family
 not supported
From: Waiman Long <longman@redhat.com>
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260309160205.651754-1-longman@redhat.com>
 <4ddd3jascnb6nt7quhyjfmsgsmtfmjofwmnrgjktz57cfbfymj@6ejbdgbg4lz2>
 <38c7a9a2-a8f1-4ae2-9070-73d0ebb42f53@redhat.com>
In-Reply-To: <38c7a9a2-a8f1-4ae2-9070-73d0ebb42f53@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Ap2VU8WSTXIjtF7jJUEU2mdjePj7XTx851iwIywRb9Q_1773151747
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yukcdeo3bajztt4j1pygqs5kkzrutdzh
X-Rspam-User: 
X-Rspamd-Queue-Id: D7BEAC0012
X-Rspamd-Server: rspam12
X-HE-Tag: 1773151757-512746
X-HE-Meta: U2FsdGVkX18GY0TYVA9yZlLebbxf7XiUtANkK02Cob8Yj3OP99Gbm8nQGMJ+b1yBipB0F1Olo7uWIFpZzBQsHU2A+YRFfpbj/47exUdWDkxe5QwxvBSdOVQAQVgBEEPCJ3iuxu7hv/Hizs37uyv6vSxMwT7P0slSiK0r3Qzof4F4TKerGSMUTTGo+7TRPgW6mp0HTQqWsxGPvuHICWUtBpAEoaNcqm8wgEGqiKDfmZ8u1/lKw/iyFPBEo+2cTyNhpmzFodtW4FzsIrOZ2sTEaxl3kZY35BonKR5bmH8yFck2xZ8jZ7iw6p2EvSN8hyaECuFHewqzjoZr9UJVIk84/j4OnsgqO/TwLUsPu1Ph16A0wRqpDZMPoxTXIC+IToLNE1vGo5o53YKEBnmV+WZn50VUmRWgOXKCBWLUnl3pysd09AiWImbVF4QGKb2e7Xg0x6jZH37TX1rdvCNq8qQ5sN09IIGtoIGSwxBq8IQkoDIepq2vje+RS5Hrhv8/0POh784zbVUiF1JWflq+qT6qf35FIjnunP3pa3R8+B+zwNFZRT7SZ6B3rT4Fpgh8FldQALD7+YRUYxC8GbZUpayAS4NB1USrDWMTWELyEHVoOVv1bL8f5kBFE5idLp2MTZI/6DU63+vH0+orqkrhk/r+O2vteGmf2nCTnXVZZiBSLjVdSCcD0y6Ck+Z4dMB5yW2JqQsL9ZMkmcsOWbbadrz9pu0VqjttZI3O/jweiYT6Jxp+FnqTY6pv1y8p0JVLiU3amui/W8TBUqqJm2C1+q9zUXMGd4QrVa5HxkaaqerBK2qzSSIjrbC4xwsv3kjUU8TTocZRIcDaMLZTW4DMyd0If6UOemaxjh9PAzjimNsIm49Sa90F9EafCZdaqYUDAjsKVlXPG53Fo/V50mUEbvLHlVgQOcyY8qSOdy8/+mzIujeTG3EvHOK7ginpp9j7y3zzRhQOgRiQs8bQ6mxke5u
 2D5fRwbu
 z17iqlxDqxo/SBbCUTU4HSyfamjp69yEI574pZkSXES0Xa04oXC7GDUXqW4LonB8Qt1VKzg3Q4xM2Gm/m9ODd3+QpHHv3vGigl5RFxsY0AeG/9hwzHSGSRXnHs0PCFRI7K3mOz3L0dkvIlJQfLr9uXj860yih9G7IP8r3wRIX97Fzyh9XPvXVoZzYt8+10aQxe07JgLR8un7OWc+oiHKsrrPBuGwFx/Ln2QZqLIjGCGvm2Ku8w8xDdse99H5ep3KERJhH10hve3aWzJMZqYGsUEda/hBK5iMQXKmI9N5KAd11rwNoaudKMAQxWBcrQnv6UIDDwaX++v+CnUypMFSR/B6NfTruh5TI9270ADP1oCTv2tJ0I/414FTa+uJXwggta6JdKvpeSrvGLqsPhrqt3D97afv3pw46UUjZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 8:04 PM, Waiman Long wrote:
> On 3/9/26 2:07 PM, Michal Koutný wrote:
>> On Mon, Mar 09, 2026 at 12:02:05PM -0400, Waiman Long 
>> <longman@redhat.com> wrote:
>>> On systems where IPv6 isn't enabled or not configured to support
>>> SOCK_STREAM, the test_memcg_sock test always fails.
>> I think IPv6 is not substantial for the check...
> I mentioned it because the current code is using AF_INET6 family.
>>
>>> The purpose of the test_memcg_sock test is to verify that
>>> memory.stat.sock and memory.current values are close.
>> ... so this should work with IPv4 too.
> Probably, I will try that out. 

On my test system, creating a socket with IPv4 does work. However, with 
IPv4, the memcg_sock test becomes unstable and it fails half of the 
times as the memory values aren't close enough. It is possible that the 
assumption that memory values should be close aren't quite true with 
IPv4. As I am not familiar with the networking code at all, I will let 
others who have more experience with the networking side to try that out.

Cheers,
Longman


