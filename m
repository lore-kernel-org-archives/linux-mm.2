Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C652FCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 18:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197528E003B; Thu,  9 Oct 2025 14:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148258E0002; Thu,  9 Oct 2025 14:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F6D8E003B; Thu,  9 Oct 2025 14:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E15ED8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:52:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81E3D46956
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:52:03 +0000 (UTC)
X-FDA: 83979470526.25.E1E1A3A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24C7FC0012
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:52:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A3nOgkcb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760035921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JuM/xy0uDi2aKWqEBu4ShLZn7rdYhN1RSBK1xoj3T/Q=;
	b=kdBW34G4BJMUV5J+B7N19qq57Vq7iH7eKqKEj8kFaEOyxyCwDKiV8fDhl9uLR5YHZ7PKMq
	aO9OihHK0wpdxAIqP4T+ghvpupjOpzWl9b6iql21VHc8TVOK51dRMLwG3wpsQI0OZ0UzHZ
	NoEIxWrNZUOH5YkrsT25HxyXT4/hG0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760035921; a=rsa-sha256;
	cv=none;
	b=liZsjJ/a3Q/QsBoyDGjY5m+4aekSi89aYh7StTwaTTz3ZtV0lcPpwzXhhNlnQxzBqHqxbQ
	Jt2E1Qjc8UgnhJm7VbrilX1GlC4P/GDQ8yRCFiUusGzsrb3D9o2iBVd8NWErxqG2z/7ini
	/A7XrmL2n9koobuVpRy9ZcOtGdVP6r0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A3nOgkcb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760035920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JuM/xy0uDi2aKWqEBu4ShLZn7rdYhN1RSBK1xoj3T/Q=;
	b=A3nOgkcbhgoczA4ZT1S9tbGhuIEYYKpADGmedn8krgR1NspnvKWoTVWpOsPm1PxOZozj+x
	9WJAy+4Kbqw2/IA1I/4DD63othwnS2ofnhjUR9jtrGvBrP4e34i3UofMyifrNnTmXLKq+E
	S/1FqbZq7I6ZVwScfMd5vP31HhmxY8I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-7SjCUKV5N5iVo--WaY2sRQ-1; Thu, 09 Oct 2025 14:51:59 -0400
X-MC-Unique: 7SjCUKV5N5iVo--WaY2sRQ-1
X-Mimecast-MFC-AGG-ID: 7SjCUKV5N5iVo--WaY2sRQ_1760035918
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f3c118cbb3so1333221f8f.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 11:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760035918; x=1760640718;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JuM/xy0uDi2aKWqEBu4ShLZn7rdYhN1RSBK1xoj3T/Q=;
        b=rZ9koBOh2xbOIfEx6YtZ/OPkN1IYq3PMx19aFHyL2ujUHmnRiHA54bpucWMEZ++zyY
         hpTElQpWVvAbrqmK5uZl/uchx9CVP3TdtBfHPyv9pft/LDp2nvTQOjlIm5yj7o+IkyKE
         zHKJXTx6YbDe54thi4QplF+U9obeMQ1P6EKSRK1LDJVp1EBSfbyWkpOsSZGzEQvyzNjJ
         pvPegNEGiZV6yWGc2srub0MHSx6r31Ha2C8B7+k6RsfMgY0HDKwUmjfVndOx7ulha5cX
         IZ8WoE/cb4Hcso9mc/xIAJUo2h2bGR4pFE8+nWaDlDwR2xTy8kf8yBh2XiOZ6YWN4Isg
         mMDg==
X-Gm-Message-State: AOJu0Yzv7hHg80nKefg6PySTDUXpW2jE5B1ulXsQuUpUwWiPU7YDyHve
	Oo8EMVB9JB43a/WzaAnrYfmUvtf4zbrrRqgTM35/qWCd4gkFEN+d9XWKP2h2SYfqpQ4X2/rjWJC
	ycJRuL+3rKDyMaKFDNEzkOEjW7d8ZXshASdAhfaQl5PRR6b9EPkMo
X-Gm-Gg: ASbGncv8vL24l95/jT8v9Xp2e8xSvGRlJwSd+fLmblbopBHKPnDyw7rmt+y8+tM5Ihc
	FEPVBnrKlxSlmGnwf7wqUbyNi+cdTdg3AEI6USRCFQF9LEj9lDeQ+7TLgZprJB5UxFTX41uRlte
	ScG/wXyffgNKazAQfSjNL0ap3dKEXs1uh4JUh5kZSCGdMaIEOf/Og9PeUILaX/IMN3ODFqp71VE
	Z9TBPux54xAOckMahFXVtNgpzpmuZgEy4yx5KTuH56FrRjAKhWvIdg6plS+4Z7ElRh37mFUFEmT
	KEOblM/MfyXkBMZLd2uX59/T4Htp4BRBQQA0AURdZSUvgkDhMRzSOSm1SU+SDLrGQdG2ZFQl7S8
	8lXGHIfj3
X-Received: by 2002:a05:6000:607:b0:424:211a:4141 with SMTP id ffacd0b85a97d-4266e7c61a2mr6181022f8f.27.1760035917767;
        Thu, 09 Oct 2025 11:51:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9phgoJQqtDuGkZ35opgptVXsnLjQkrMgDx7RkFdRbInqtHP9Q7Mvdzi6WvZ+AZV1w4gKU3Q==
X-Received: by 2002:a05:6000:607:b0:424:211a:4141 with SMTP id ffacd0b85a97d-4266e7c61a2mr6180982f8f.27.1760035917202;
        Thu, 09 Oct 2025 11:51:57 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce589a21sm383854f8f.23.2025.10.09.11.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 11:51:56 -0700 (PDT)
Message-ID: <ac0393c7-9c0c-4b4d-8b35-5e6369e5431b@redhat.com>
Date: Thu, 9 Oct 2025 20:51:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
To: Gregory Price <gourry@gourry.net>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
 laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
 joel.granados@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, David Rientjes <rientjes@google.com>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
 <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
 <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F> <aOdSvriKRoCR5IUs@tiehlicka>
 <aOfU9YTKMPWzYOta@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOfU9YTKMPWzYOta@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k3LauTw1jiP72a0ufNxVeOmvnENIoY5E0htw6cjIoQ8_1760035918
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: dtsjiz3pjwjyzn8fqfzmnyonmneth6s9
X-Rspam-User: 
X-Rspamd-Queue-Id: 24C7FC0012
X-HE-Tag: 1760035920-284098
X-HE-Meta: U2FsdGVkX1/g+dgxMX+7ezJqgnrSKsS+MmTnuUZtSRKdfM0P/fepLekqCkZ6UOmPAwsVsZtqSAsP69jA0NFlMsKFJQni+vi4lfVUto8gxjTcbPK4k5k5uVWaalaOhmKxHBnN2kVrKSuQDwO1R3KQMgtD/0b61yw/56TJApATlUCcUagaMeFq+tB8SyUviPGC876PDmPs4LJx53JRGA23WfV2sDJbuOrDanm5QwEfpOQvbuA6b7NWMSaflKCpIUGhoX0+yivFfEdOooMF8CN8J5yO7SlbRrVQsJBuDZKCrLxoc3a+aenn7xOTYO/rRsDTLTc2HBuwjeyXvsihsYyTCvg//tT1w3MZWdfulwKu48UfPxmaCrA+if6EbZDhAwNjlJXPBgt9uQOl5vQe8PBEUZapOEvsxpsq+q2kuLyB0vQ88MUH45cu5FiWbeRXu+zY3BF9+yELw8M9RHBOYDia2Vmvp6WNqoq+rAghn3zJZrjJ3dX8oahiU+1AkYsE+u2Iy3LIvoNZX1aYlFexT8p/P/Olh5itWh8xcDdqhPBFd/zZRSh5nUt1VLgDAC3GMeBg7jK6003FMeSdqKnVG8ZlvHnzZ8c3i/kXAYaMwTQGrF1Nw2rULVO6Z9+J3eb17u3SPXHz5QtMOeFxlSPVHTld2sqBmX2fRXDxdsyJpwsNxORrs/6CViZa7NQ6rmjXP9GB/23Z3TFJ5qX4HhDhI1a/z4AjUzhkpmmJGf2yioI2Mxcbo+hn0PSBy1RAqMDO9IqOYfJXvlRiTbCgAj5TrjRyTJI2nFBzYWBpc/7Kgukrd5jBdpk7MwAB5aytZL5e5V8/nlbGti3qRUP+bqUEpHnWBbTsaYJlKZk4OmvtIgoHB9EAAWJ31Qd2zCcSHeYxHddEliLd3gkIywz/ery/iCLbGfJWKZ5bKSLzzGrrdO5v345yTGVYNF9hG0bOirOETmxqbxJM0U4Mkhtw1Wk2tWT
 coOMi3NL
 +SU2JVBiRqtpmd7PHVrnW/zAVh3SYSLEbJf+JVMCfKLxyAb3SmKQwZOufMqjpUQxXjnQ9FrYgi9zAwa3Xvaj1V76U+KT+8ePWf9v/Sy6VC35hvHKwDBxolTgeQgvNZJT5BDxYJ7I/XIJleg820f/6r6XIS8y3jlI7L9cZ1Pp1p2yeRFpptGBem2zAAjBtvZD9fGvso3WL3lA4hLUUslgZx+L1u2GdwGsYSmq7IjE1PGzgi6p4OaN2DTQqlO4T+12mq1zJJZe5/k6Q3ybcNYHcBcsIe9EAGIALQbVqpjMsezr7C7I7ITyosY8m5KbTPGKa8+GPQiN5qEnsUe7YDwLUy1uz4f8wvimxlwVu3EIcbrFpQOPU8S8d7BvnHC1lNsH/rLWSxKnuUnBClpsA4jlVpeQblA5pa5IYAHGcJTzyuGKwq51MYCkw57t7nifatG5itao180wc7Sac+JvuUW4MzLQSvn6lmLehmms6MhOxP7UkicXLGYTIYrvOUNmtwT875Bgm8scANdb+tRbxn+OHZbq/digLinQIGb2ofJpewkgfPchipPbkDciX/RgCObbKYHrlPPHpeunWFf90fhJsELm92RdrZ0NHjCTVB9S5AHv3HJhKtkz7t6TA+7uNsrkwFA05ON28iYGPg1rOglsU3Hdt1POp8DKOo+dx4phXX/Yh/JzlJHI/H+fGDqyFHblXz8ku6SAsQJWKUpQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 17:29, Gregory Price wrote:
> On Thu, Oct 09, 2025 at 08:14:22AM +0200, Michal Hocko wrote:
>> On Wed 08-10-25 12:31:22, Gregory Price wrote:
>>>> I'm not quite clear yet on the use case, though. If all the user allocations
>>>> end up fragmenting the memory, there is also not a lot of benefit to be had
>>>> from that zone long term.
>>>>
>>>
>>> The only real use case i've seen is exactly:
>>>   - Don't want random GFP_KERNEL to land there
>>>   - Might want it to be pinnable
>>>
>>> I think that covers what you've described above.
>>>
>>> But adding an entire zone felt a bit heavy handed.  Allowing gigantic in
>>> movable seemed less - immediately - offensive.
>>
>> The question is whether we need a full zone for that or we can control
>> those allocation constrains on per memory block bases to override
>> otherwise default. So it wouldn't be MOVABLE but rather something like
>> USER zone.
> 
> 
> Mild ignorance here - but I don't think the buddy allocator currently
> differentiates chunks of memory based on block membership, it just eats
> folios from certain zones/nodes.
> 
> I'm scratching my head trying to think of the discrete mechanism to do
> this that doesn't inject significantly more complexity into the buddy
> allocator.
> 
> Looking at the recent[1] THP support for ZONE_DEVICE, I wonder if we end
> up with something more along these lines?  But this aschews the other
> requirement of wanting the memory to be otherwise general purpose.
> 
> https://lore.kernel.org/linux-mm/20251001065707.920170-1-balbirs@nvidia.com/
> 
> ZONE_USER does feel like the most natural solution.  Literally just
> (ZONE_NORMAL - GFP_KERNEL).  This might need a new GFP flag for certain
> use cases like KVM (GFP_USER) to denote certain "This isn't technically
> kernel memory, but it needs to be pinnable".  That would slot right
> between ZONE_NORMAL and ZONE_MOVABLE.
> 
> Alternatively we could go the opposite way and introduce ZONE_KERNEL
> below ZONE_NORMAL and disallow GFP_KERNEL from ZONE_NORMAL - then have
> strict watermarks on ZONE_KERNEL to ensure the kernel is always able
> to get memory.

I'm afraid any new zone will be highly controversial and take a long 
time to get accepted, if ever :)

The real question is: would we really need a system where we mix e.g., 
ZONE_USER with ZONE_MOVABLE?

Or would it be sufficient to selectively enable (explicit opt-in) some 
user pages to end up on ZONE_MOVABLE? IOW, change the semantics of the 
zone by an admin.

Like, allowing longterm pinning on ZONE_MOVABLE.

Sure, it would degrade memory hotunplug (until the relevant applications 
are shut down) and probably some other things.

Further, I am not so sure about the value of having ZONE_MOVABLE 
sprinkled with small unmovable allocations (same concern regarding any 
such zone that allows for unmovable things). Kind of against the whole 
concept.

But I mean, if the admin decides to do that (opt in), so he is to blame.

-- 
Cheers

David / dhildenb


