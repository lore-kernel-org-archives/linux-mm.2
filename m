Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB58606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=F+Fl6qci
Received: by kanga.kvack.org (Postfix)
	id ECBD36B0A7F; Wed, 25 Nov 2026 11:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54266B0A81; Wed, 25 Nov 2026 11:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1B666B0A82; Wed, 25 Nov 2026 11:40:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A15826B0A7F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:40:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39C46A0F93
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:40:46 +0000 (UTC)
X-FDA: 85474205292.22.6EDAD36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD9DF140003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:40:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F+Fl6qci;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795624844;
	b=ljdUORaYpxyQgJGUFIcYbvknDYBaKFpjqLoFOfeCSvQNdSwplvw0+zoCjviEYPjc97jyuK
	Gur47hl15HBIX5437XsDCeI5xbVJ2cj5Jxhw7wmEYYYnDquXgp03XpSIh8uxDOcbjabrif
	YLZ5fFWcy2EM5r7SxsBWuJ2KpwhpS3k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795624844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TghFUnkx2wFDXauXnjqA/lesm0e681hvYxVKPushlxM=;
	b=Bl4EW+AmMW1W6bTTw7nyCgcHm4CUzW+8KxakWFjYff2VeG8SQt/nJsteImo3Rb6Do1DkDs
	2Rb1vIcB0qmQ588aKKLhYVN7YZhQQ4bVRg2o8yLD0GHjZhT0o1xasuN5jmVgfRq/cj6tZV
	hPTmoJdioOpnCFCv1EE3XeOSQeZPPgw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F+Fl6qci;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795624840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TghFUnkx2wFDXauXnjqA/lesm0e681hvYxVKPushlxM=;
	b=F+Fl6qciy+1FEGnVjSxXymAaC1MnpLvqgJ9Nl8E+l65p1P3PRyQ2c/glyWtLoUeopDkazD
	tVZRDCPG2V/ztz9ueLceY48YeH2n3RlWlU8InvCDNrF6U2aKYIBjrZxE63pCAYxAFjHnBX
	2DRorrgT43KqSLWgD45MoqJE7rvFxI4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-suVtOJ6cPfKZ6fsDdujIPw-1; Wed, 25 Nov 2026 16:40:15 +0000
X-MC-Unique: suVtOJ6cPfKZ6fsDdujIPw-1
X-Mimecast-MFC-AGG-ID: suVtOJ6cPfKZ6fsDdujIPw_1795624814
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5c319d442b6so1358216e87.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:40:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795624814; x=1796229614;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TghFUnkx2wFDXauXnjqA/lesm0e681hvYxVKPushlxM=;
        b=V1ZR0Idyn0wOvRAX0ejYE9k2dj1Kd+pvIGFALEKmUnGi3g7TXCv56F/JJ5JadV99in
         PBgBBWLA45fO3elID3wUEz9T0ZNHCK8ZB2BylyMtYwutDLQ1PPW2cfr4HtXbJnJkM/Cz
         KxSGMx0rdFT0vgH0LFB86jxayp1fawZW77BYHuky2XlZS1RjQ1HF2HDmwMGrcn/G8Nm8
         3dw8eIMPJl4PUC4XZOb3BC/oEVHKUlnSaJyGOCLuF6vJvHFTxeDa1t3uupwSOMwzy8i1
         +4ariAzWokNkI9FhLrpT+fplwjvgb2XOfFUh0ELnOcLu/FUOgwEEXaGMZSDhEMdeQKCY
         uW8w==
X-Forwarded-Encrypted: i=1; AL+hErEcrzKFDUzANyaMSfCdaG2VnTCXYmeMQ8NbeqkXG1Jvs82dJ0qmDaoAgZB1qnQYnUT0vDFFy14DIQ==@kvack.org
X-Gm-Message-State: APuU4Z/NTmV96fiFKGsmHXzUB1MLXS8Gr1wNTfNKUARdZ4HDXUvSKzzV
	vzRVci7TCw0bHuw+S4pByjIj1tvufngwx1KunW6RtDZ8M0gydWJi/zU7rJLmTu7cu0efwuZkVYw
	+rhSI08R2WuN/O454qw2jkjYZ0Q8kPCjX+goFd3tAY4PJ4CZzsCQ=
X-Gm-Gg: AZFdTZe/uRLA2mX3QrKVwQXIJzQWtn6QbsqrbsNejiR8oH9G2lfe5FsEW4kJNyrBCoN
	md/vT9z5IX71tFtBy58MjDAALTwvYdN7O0X7Q0jTXMKrvoxxdOU6ZyG3nMdX+jlpUO0nFFyIUiS
	Jfc78VsaUFyHBce4xE/Ms9IliTCWegK5qR+0ozSvoM6MjZtUYE4lgnjEKaV31GPX/AMj7NivoTH
	pQpExFP5Ro6Kgqi84+L7ZPvJ5fXJK6n6eQOdcitRQFMDEOQIvC1oXoanbhwnlIV3Ai21Gjs5ILK
	y6euozZwid22HQAW3ZHDg0zK6TEg36YYC711ZgLMGfLqlZt/FVbSraUQAwI9kqIU5J6zsq1x49H
	rrOBDqGejQdV6EkWzXsuxVklwaUsUamhNUOid+45T1aBEyT448Qufy6F0NSWhe1OADvUgSNLpqz
	0Mofl+
X-Received: by 2002:a05:6512:1320:b0:5c1:a8c0:620f with SMTP id 2adb3069b0e04-5c1bc817e34mr5223596e87.50.1795624814156;
        Wed, 25 Nov 2026 08:40:14 -0800 (PST)
X-Received: by 2002:a05:6512:1320:b0:5c1:a8c0:620f with SMTP id 2adb3069b0e04-5c1bc817e34mr5223585e87.50.1795624813706;
        Wed, 25 Nov 2026 08:40:13 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd0176fcsm4612398e87.34.2026.11.25.08.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 08:40:13 -0800 (PST)
Message-ID: <be640357-419b-4c78-8d96-3c698424ecd8@redhat.com>
Date: Wed, 25 Nov 2026 18:40:12 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/test_hmm: invalidate all mirrors on device-private
 migration
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Aveline Noir <jm5905938@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Ralph Campbell <rcampbell@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Shuah Khan <shuah@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 stable@vger.kernel.org
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
 <awbtZjtII9h1oJ5R@raptor>
 <CANOyQmGPHrHAzVW70Q8T3AYtzFi3C7jCQdd-QW0rQCPEf=ycyw@mail.gmail.com>
 <awb5agUP80qz8iss@raptor>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <awb5agUP80qz8iss@raptor>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3C2sKn2DH353LMfX8ubjDdAx2pu5vivzwjDExBYXckg_1795624814
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD9DF140003
X-Rspam-User:
X-Stat-Signature: cafngfnjqgjxgzz5b1gehafx11t6typ7
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795624843-264098
X-HE-Meta: U2FsdGVkX1+HSHh6bwUm1Z9Miw9KD8cGerQAzgsV25WRUlxbtrb7bdlQqYLBmZIJwCKkbcBWz0vn2J1GjkJAoP5uooKhSrwFulxcZFLwUK+MXuWYad0Bz8EN1tBppEKrAEjvzD7jxNqd/JBEXF06tmGsi1fVTMammcXq1WO5gJ5CZvAX1ABaNQb2mL83syndJdn4u5EKFaPv2HvzLncj00b66+AqRQvGHvpnOdofDnqbDvbj77yyUtZse+rimyi2PEw4FXK8RCErXLtB8vbtQUCJvlZzT6qVhlQZVudxOfdL+xDM9Uim715bjhGaS1+IROjwfBYggOyhTDctCVDAUZCs7FCknC1GyZFBnlTLhaJgf51rvEh5cKNp8mPkzmVOyDPSEjtpYqtbrH2obx7V7IEw9/l60yldtIoO80tIUEbniMX6jKxozjM6a62FtGgIFSXh/T5GGeYFfLzLcMKX6VHYObQEaW5hU8k19xXAXA9SGPD8Fea8a0RVqH4RBoCeplH/RSRspS2yGltMkUjFIIrjKAt21+cdPROZu15vkjlUhQbVNUzFin+CtlfE34FtYlPFK2RIvOgtHG1Al34cG0z4BZH9fBjT4cy6kQxiXilZPhfdBNBlEQuPnUCdmNQ2jpp2xkE05e7mra3KzSaAgOe1Y4M7DLmW+eCtKhGP8zsbwQeEFIuNthOqpWQZ4T0FV4pzqS51o+gdGyF7wn63XJgX0rPnitsa7vY6PO4bthZ6rcIggsOoLgx14eLT5tUDO9qZxgBaHWJFnwArySpMwNK/rWJZ0YzsR/XYjZRijJ1OCBRNEOTLH/dOEQ0A2u8znBiJe7hZxqQhR7q9aPK4RJIsJersKrUYgVUyabMcXPHPpnfIdiF5T/z+AFHn1zTIcbXXxboAw6xL88XZOumT+iY4zbZXBuHhOaBvMRthv35zsv4IxWKsj0OZaUdCn3pZmDHpHeMfzGkM+twHpw6
 E0ej6WVF
 1SMbBVJWwvruSxKN6vOu7nSoBC5NrSm5rqKj+GDC81HCq45fOtqv/Qrv7e6SFDEMxRb1NIC+si1/e4hJXrTL4tX/jacYvroZrqcbuyN7uoo72xaddR3cKeTrkzNVi0Oli2uj0oWgcqKKTNMfzyCp3/HzkjIb4OD03OA/jTmxx/t0eL6eW3Ud0XCNoOzmX9jEUDPJ45drE7Gviv8UsRvu8fyPTfYZbIK9WP3nI3NGx5u7TdAEiv86abZgq+UpiK6IKnVpHVGlDWcTBVDl29aY1PIQNcg9Iz5pk4kf1aWQ3m/SA29SBlQOZVd71Nlwx5X0V6qfdGiTuaJm81ueUmPqpHkISwOmexFV+PB3HjFd9IotV41gkeo4Rk32IDQABYLKA2lF2sZC15VISw9Gfw8ikOvZrZkZSw5jVITyCbmswF7ZfFgZMDeG6xpe642hsbXyBXq0EP2LxK5Em1Gi8W3cwvM/CqtI4ZrZ7XulJ48T38uhaUmgmr/NlAzzM532CDI7CJkNbEb5V+sEVehzthwANhLefzf1Q7qEibmvUQkmelwOqLUfaqN87fVLmCnL5jxpb+oppGpFkrXls+NR9/VQJzlLA6fM/f4BhhR1QQw1dArkcpckm1T/MZGlZa8x0gCe6A/AlpH5VxQe38qTv/X1GZi0nNI3bXAkMaRJbLh5wvrA6Zsk/gQGlLPgHt/zb/dGl/2VrF8xXOzPgRXO6GqVUIK4sfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On 11/25/26 17:06, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Nov 26, 2026 at 01:25:41AM +1100, Aveline Noir wrote:
>> Hi Alex
>>
>> On Thu, Nov 26, 2026 at 1:15 AM Alexandru Elisei
>> <alexandru.elisei@arm.com> wrote:
>>
>>> Might be something on my side? I'll investigate further, but I'm not very
>>> familiar with the code.
>>
>> I reproduced the same 0 versus 523264 assertion on x86-64 when the separate
>> mm/hmm: account for subpage offsets in device-private PMDs fix was absent.
>> With that fix, the test passed. May you check whether it is in your test tree?
> 
> Indeed, I didn't have the patch in my tree, now the test passes!
> 
> Tested on a Radxa Orion O6 board (arm64 architecture):
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Thanks,
> Alex
> 
Did you run the full selftest? 

Without skipping own invalidations the normal migrate to device test fails
( With no skip, migrate_vma_setup()'s invalidation erases the caller's own entries) : 

#  RUN           hmm.hmm_device_private.migrate_fault ...
# hmm-tests.c:1023:migrate_fault:Expected ret (-2) == 0 (0)
# migrate_fault: Test terminated by assertion
#          FAIL  hmm.hmm_device_private.migrate_fault
not ok 14 hmm.hmm_device_private.migrate_fault


As told I will be sending a proper fix for the two fds invalidaton case as a follow up to my other changes to test.hmm.c

--Mika


