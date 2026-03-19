Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C699107526D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A456B0419; Thu, 19 Mar 2026 03:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED2D6B041A; Thu, 19 Mar 2026 03:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6616B041B; Thu, 19 Mar 2026 03:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54B666B0419
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:34:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8CBD13ACF2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:34:00 +0000 (UTC)
X-FDA: 84561998640.08.FA14C34
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id C6F1920005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:33:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=K+tQhNDK;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773905638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfnoZII81lwHDQG+q8k3CqLmv9bwI5/ooG/r2BOJypo=;
	b=uIuhHOMTn6En0nAWkxHvisbQ2WFiJ/GYCn5yAwbswsr3fKcgiTMRAg+Aoi3bjQD1Q83Oqw
	T9IICqSZNH6ZNYGnr3hdjGxdQ5Bqas5x8f70l1+CYWl9zzu7Dz8Bqai21UiJgeI1oqvCx9
	rT9sAepY+Bzn2DCU+q5RmXKREuza9xo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=K+tQhNDK;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773905638; a=rsa-sha256;
	cv=none;
	b=ZceWImpb2XWneOHdq4TXQDyi6jtx4Rov3nU5kdla4W9ERwyvtm0KGJLxzW8gxqVhikF4Gk
	0ORE050YNPk6XOa87kque0palcMy9/BT50RHWYt9XTzCEwx89kppQwdeCApst9vxSrZhIj
	6Mv0tPh80JQomJNmQ068RJvSH1GxW0Y=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso546528f8f.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773905637; x=1774510437; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mfnoZII81lwHDQG+q8k3CqLmv9bwI5/ooG/r2BOJypo=;
        b=K+tQhNDKuRNUkyr+7NmwNoiDPPwBZYg511X09R+IBkoZjOsdWQu20Kd5j8ckaq0/7q
         r47STWB4FRknq8N69iOgf37lL5pDksjNw5b08oJIHxjXLFcLxwGW3/NWEFT3iG6JXsac
         MMSgp4iuzseZ6IrzOcIEQGqfae9e1sOlknPwIjH1r52YdrqRQ5WmaYWVH+qZJj2XXmsP
         WZHEhSsVlWfb1qVLdrvhNNvZTQnIrcMGdlp9L4k5LQgps1SY0hSw1/rGYRKQwUICR6wx
         cefRZDh2WDAI920oTMtGmHBoUHrdCOKr8T1uU0rOHP8kIDLCzc+NmLcffI1wF7S2BetS
         aRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773905637; x=1774510437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mfnoZII81lwHDQG+q8k3CqLmv9bwI5/ooG/r2BOJypo=;
        b=A0duIo0CcGjboZKip0u3im18b09XTw7OvXRAy1O7eGPBEVJVv9F0xqYW9abhKic2SY
         fEflOWOyTerbHARC+nwrCiqltrv3S219pIhDmsSsMa3UZMEsqgnL3kYgE/bB24Gi3JtR
         zMD6tzbzpX0iLVZ87jPMzc4Mscpux3pD9cREqLk6Zi9I1qZr+Ma0SfmIEnxNIObrpgeO
         86mBqF/cLuTiGCN9DWw3LfIDO3OL6TQP6WGw1DnNLLo5bEb75eeJjr79Lo4KNCeFWp/j
         UgMN6vxt3hVdFF6vQnmTTmgzt0X19aytDglL7AqQsY934G679ut7vip3+zAj7GM9DSUu
         fAOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZ+zRF18s3HJbuEnFTZkPpU6mLMUWjsABsuO6qzelWXRnLVHCeUnfeTK68VH1o19aBaCKzOPwCJg==@kvack.org
X-Gm-Message-State: AOJu0YxfL7n/EF9aJyYDIgz3WLDYP2H8sM5C9QLRea3IkPLHO7kzispi
	qd0wiAgXUqv/05goVQgGzz9PRU0QjLeXbGwnHQ5X/aMg+tu3XridU1JXlGtGDRWsZX4=
X-Gm-Gg: ATEYQzx3Bi7rdkXaJqnTzRyxO4aJ1GQjO4XaL0aAan9egbe5QXehfotcFRtmjWB9zL4
	mRIhxic3OaU+Od7QJNSagYqfX6H+UCY3WZ4IfzGlSEzKbt8AynuexI+eWOef4az0SRxT5lc5EeZ
	1ozjNHVCEUJGxXQMVblfQsyxBWrv9QLKpCoQFddjJ+ZgMYS2b2KDYjCamdh8fpVfBSAvTeOOh0G
	imE5jsiUyO9rMHt0xGigm53MC5VSksZfZce+Zq6uxwCDwmX+neFuoU5+lrmlCGG1MaS9E8hylOK
	fwZw8b8kvDl+6uvvtTXhvKF//6diHGf5AIoajs+asw5hYUZBq9gzMEGPIrD7y3IywbGt6RxXx2Z
	EyppQwzoJa+tWMDumdtvoK2AAPCTjSM4TQ37fdlZHtXd8gqh3KtWav2ZLN2Vd89TA8ZXb2snZvY
	LVOws6JfS72FtGBbfHvl1OxmTYvsY8h9g=
X-Received: by 2002:a05:6000:25c6:b0:43b:4ae5:d7c8 with SMTP id ffacd0b85a97d-43b527a50cfmr10368836f8f.2.1773905636943;
        Thu, 19 Mar 2026 00:33:56 -0700 (PDT)
Received: from [192.168.0.34] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b51899622sm15875212f8f.28.2026.03.19.00.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 00:33:56 -0700 (PDT)
Message-ID: <46c47101-2672-4970-a212-71e2c8555d80@linaro.org>
Date: Thu, 19 Mar 2026 09:33:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/25] Introduce meminspect
To: Bjorn Andersson <andersson@kernel.org>,
 Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
 John Ogness <john.ogness@linutronix.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <abdnp90cC5PI9wyz@baldur>
 <20260316181647.m7x4ncmwdjho6yvr@hu-mojha-hyd.qualcomm.com>
 <abtlUQqMOxj5PwGB@baldur>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <abtlUQqMOxj5PwGB@baldur>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6F1920005
X-Stat-Signature: u674x7kn14fwcsqe8m9uw18ein4q5pzf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773905638-663073
X-HE-Meta: U2FsdGVkX19gaZwECjbvNNJNv8AigiYTarieJA8cXA7sK9aS5eZJT0ZSMm9++is7x0/GiNdOWtvu3sMdmGrsg6pNvcl5nGjPQYjJJ0R9FRVnF+xapjDkeQQgtib6yiM0NYt+beWLiEJUG8SDGT1ak23xCpeUtfge2Gw669b/GluaaGQVN8VNxdrDtBZ7Kg8xIpJnIJ++mLQmkWVVW5KBmpvV1nnDnHa06yG2tRrwFM7Jrxt5Kopmpefsj3Un9xx4xgtS6puWQ8+JeTVvZgZgb4UBLoljrUSlNaveYc8b+nBwjCFe+fR/bA+R3Z/S2SUXvJ100/+0gQv46vhBy5BMgpiBT6lA53kykdYcvl4USRwcdnDxzYf56jiXZ0F6aW7PQsC5tnlC9I/4VzTBdiHUAmphx/cEqb9zMDGemQItM1yZJvcD9KibjwTF3fk+KwMi+vv4QnPDni7YuboJasEY8F0U2TGdqsqNy/+ZnEVOWT/KJ08SovpYIytS0CVJJcg9sIGCZuugAVSOjhkBZU2uxFDHtLJCaVbhjxJHOpM8ls5bniWkB1OL4z+lYebg5uc4V/Ys7crrYV7GdojQDunqKJ0gxb2x8klli+o4AgTjDXZkbr6rQRwcN8HKGz4pgnVNZaKLcD9czVoVXpidDKDhPVvXTQkzDy9RpPVtscLiL0FlXCIq6laTvSv9UcZ247Ti6puT+nsGBT64edl/4hEXK26TwZQj6ZVAamvuTNxO3e6Nz/I1VbsbxOutjh3FpVzxnzhEvmbwfLfiAYyao0jyy2iRcBZb0uy2405/m1sZLCM5d7yg6XaQpBtnvg6gM97qkMem3PYdWgF0tnvz4LMa8H42HE/io32zpgeDPgzgWchlXDgNVWcwgZ6X6okzEOQXJMyBsXbFFQoLx6aBgvfhtPoF7T6tes9MRbDE4HMQc0jjXIfXkuMj5nGCTa+mzeyFWWwdILczXlm5k1lcHIR
 820Kl4vZ
 J4bj4B7KM8wOUUhs3Q0JXJJZc2MnhEeKbwvfEk7MQq58w6McfJmODqxPzDqkc1Y9Rmn3YOA+KJZmzBx4U0zEPKNCDqwPb2UU/LsB4ZiMfHICka/A/6MOJ2X81TsOchZ8F5wflEW1EQXhAv0S1ZYr7X+LzarmbfCoN/BP0CILuf/9PKPKfBkfkPmVIaQQnBkTSxq4x4n+z0eIwRa9ewUEfIwYsfJEocx9Lux+h2GR0cuoaNCLWBPn5WY/TrYWouWOpUMgDfycGRwImsVEN5TShuxyYwOOLH92kBeLNXe2gvxju9W9gilS1IbM+ETxy+t4tO++UBgRrCu3Llj1QPPferZejxl8nMezdeeVxGbsy4isBGMYc8N36yuLsrbMaXwzumnoDyuUODudiH+iqjM/ZxyhKrmNyULROM0xTMtvGExulXIi0qi1i3eIqitpu600H5SmfEUNb3O9oZn2HkeooM6yZidtrM//UayLhTV1tAGV9yA8ZiWe8VpfZPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 04:55, Bjorn Andersson wrote:
> On Mon, Mar 16, 2026 at 11:46:47PM +0530, Mukesh Ojha wrote:
>> On Sun, Mar 15, 2026 at 09:24:39PM -0500, Bjorn Andersson wrote:
>>> On Wed, Mar 11, 2026 at 01:45:44AM +0530, Mukesh Ojha wrote:
> [..]
>>>> , to get all the regions as
>>>> separate files.  The tool from the host computer will list the regions
>>>> in the order they were downloaded.
>>>>
>>>> Once you have all the files simply use `cat` to put them all together,
>>>> in the order of the indexes.  For my kernel config and setup, here is my
>>>> cat command : (you can use a script or something, I haven't done that so
>>>> far):
>>>
>>> So these need to be sorted in numerical order, by that number at the end
>>> of the file name?
>>>
>>> Do you manually punch these in? How do we make this user friendly?
>>
>> Yes, manually.. but I think we can do better. We could make
>> this more user‑friendly by using the section header and string table in
>> the md_KELF binary both of which existed in the earlier implementation.
>> Then, we can write an upstream‑friendly script that reads this KELF
>> metadata file, checks whether a binary with the registered name is
>> present, and stitches everything together to form a complete ELF that
>> the crash tool can consume.  Let me know if you have any suggestion..
>>
> 
> Can we somehow identify that these regions belong to the minidump and
> teach QDL to build the ELF for us?

We could integrate the feature that Mukesh suggests directly into QDL as
a separate command
e.g. qdl download-and-build-minidump

The first region (the ELF header) is mandatory, because all the regions
themselves contain only data. To be able to use any of the regions, one
needs to know at least the physical and virtual address of that memory.
And this information is saved in the ELF header.
So QDL could join together all the regions into a single crashdump-like
file.

> 
> Regards,
> Bjorn


