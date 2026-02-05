Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47DBEEC1EB1
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B4B6B0092; Thu,  5 Feb 2026 07:57:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815406B0093; Thu,  5 Feb 2026 07:57:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E896B0096; Thu,  5 Feb 2026 07:57:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57A256B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:57:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12D311B26CE
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:57:40 +0000 (UTC)
X-FDA: 84410404680.05.EA59D81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 45F5A40005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:57:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MoV5InrA;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770296258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLu1dLua1ztF/+2zCFrLhdf5JjePC85pjUsEHIkGiYM=;
	b=CmF0nDSOOtDCEXo8tVmzUFt8bI1eHv2MkioR1IYcVlfoVcXXnaI2ND7PHEZ3TAAdyalAqs
	TI7voxd7W1WTC9CmrpzofGr0peWWgZH7UstvnWt1FSnKFYg2wrJSVnVddvEc0qan3Ywhy2
	aKTK/pTIa+1fsBbvteZEb0BHu4bEyzQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770296258; a=rsa-sha256;
	cv=none;
	b=wXcy5nUG7CS3Io2q3iq4D+aunV3VQv5ThfMZ39JTUapinOwjlSbnr5kSVfCyD3DvZ9zNyz
	Bf8eUJghNtRSwXACqtoQyZdLSQghZAm/hFfm/ZmuBYJwbd1/Db8Pv93YHwe1NDeo3b4P7R
	2fpdBeBVRJEjgt6HqDEIdkzoj1Mh2ZI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MoV5InrA;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29BC2441ED;
	Thu,  5 Feb 2026 12:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA86C4CEF7;
	Thu,  5 Feb 2026 12:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770296257;
	bh=NzrP3+NUwRJ/q89RDVNVAuYWq1j4naQQFI2LiUFFCyI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MoV5InrATbtZXoUmriUwqZZsK5jWlWG6uCom9s3pMZr+M7Mba0TlPeSrqL9uuJPnP
	 7KdEleeoMn8Hlb0tih8bQbtVQcDOBceSLsCI8PM0k2UDsb9zaA1h4atZsThIAVwgto
	 9i+DkTf17v1+M+PZuXiP+g2Pqq9sq+6FTJN0Ckq3HeZA5yE1Z2uOWvj+lCD/fM2D5u
	 PPZsRkgdO5deBXC+ademeUo4Y2UTO+blJVo83x1dIFU+VDZf/QxDmqcjc8dyj0B1AY
	 8/0IpX8GyelaPUVuvJB+ZKqsKPOcwcMgcg27jo5YWo+3Qx1Y4W7U8IZyTLKjc+NBlr
	 +hJkskpjpA4Pg==
Message-ID: <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org>
Date: Thu, 5 Feb 2026 13:57:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
 <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
 <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 45F5A40005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: khhr15i7syfzr1ssuu9ibtohid7r1oij
X-HE-Tag: 1770296258-749062
X-HE-Meta: U2FsdGVkX1+FA/j0ZKyIP3C9KArz9sUVRbyI1Ed9vAvmYU9fWOlO4NoMRYwImtnceejy2Ek09NKaii88CTjey/1WWs/3CZdQnD6OMexZF7WIF7/jFUTLON6A3+GH2q63BFZ6/mtmbC+ggf06LL0gmhyM2DLSlHzh/jgxyYG4j/6aT+EeEsVY5ww2xTxgDy4qYMxog2m/oHUCje7RT3Qhsyah22sAXnZHBIr5RIWdvVLcJV4V+nMVgfVJb4TAY49eHYAG5qwrJkLmPReqrIwdYM+lUA+5rJybs8NOpb1J5aJxcY9t/MP2M49zgLZwP+AIv2TTYrv1H02oFsIYOAzD+JIuka1zuKMr5URQfoNeC2/8aVf+4mWck9E2XM9gSLbZHAA30VS8H0VaL+29XvQGVeAUOo+K5DhHXhRl/dqA+bgL6iGm3rPbNyjUd/jT9WETn8dBouVDTBcBhjXFfTAJooY345VaoWYrSE5s+5V4oLmUvFvI8VDIKFwyqRs0eMre7Hk7wyWST78eRGxNs9qIKxBkN1Vtka7IPRhyc91l0Wry/N+qQAJ9P/XJedK1gebP8ViKh0iYtfp8k93Oda9xj2POUbtL4xrMSsCOn1KOHmYqSAsZHJuMyJwC9/c/iqqCD61P/KirZoOdW9u6sI3H5cM6uO//u5a2ip8LBFdtmJvZj0otXtOlVqmi4TPKkl/zdCoOhsF5C6TOvT2GV2YL7SZAGHqczp4wt0VaIe7ZgegiHAp5OFhUN2stpi/wJXkn2ttv8NkfQ7XtLTTeFPjn5Gg4YDQIuC9Kj8fI54lQ9oHw7x6RnxAlAE5YXgKmT9pB9nRfAz0SVSljDX0HBBMhTxw0cQzrEDxUTtIarLx3y8qKYlJOQwxMBumTQi7av9VfyLgiZRGSgo4mHPu0ZZmFTWSEaW1uLv4EC3tF9BkJZ8MBb2Za/GjuDuJjOI/QzkJOIQkGOFbPH4x5wDzWpp9
 RGRUvMag
 TG+Uyw7bHWSzecMOjWH+svZrQncYPq88/P8dBdjqA625ebV11wa6gqnzn+BKXwREppIr+thViWeuzKpasK10QMVRa0Lxw14kKlO9grkq55C0jT7ZtJuks21z9GA2fcngST2yLYioFbXBBTn26Zz/Qsy6HCX0pnkKN4AIFkRYjvPVPdAVdt62alRG6iQO3xH0sCsm+y6thrRVztMYQJJk8eKEUUZTPXmId1wefV4hhapw2qHASrlFz61kQ6SlqqWiSLgNo0AQJeoeyHl7I9ky5h0wpN74zKlxoazaJy/ZYM4br6hXkYSV+RvnprA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 13:46, Tytus Rogalewski wrote:
> Hehe, i cant. I dont have any CPU only servers :)

But you can just not passthrough a GPU to the VM?
-- 
Cheers,

David

