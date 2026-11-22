Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4BE606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 07:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=lxi5JrQF
Received: by kanga.kvack.org (Postfix)
	id CF84C6B05B1; Sun, 22 Nov 2026 02:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF696B05B2; Sun, 22 Nov 2026 02:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBEC36B05B3; Sun, 22 Nov 2026 02:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E70D6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:07:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECEBD160651
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:07:52 +0000 (UTC)
X-FDA: 85461875184.01.0F530E0
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0592980002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:07:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lxi5JrQF;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795331271;
	b=REsvaRmuphOcucR/tWBkGJjh6GwPWUsiEzCRu1rLuQgR3oH5VW6wb7rqi5LuWlGuqJ0Rdv
	BiQ3Y135Sxn7+dmJwmjyVDFiFZpKsG6G9/h8yKl0fpIV0mWF1fDY3jpTT8m7YgxVTCImBP
	16qvQbBmsCMneRlrirhw+uKy6FWhx60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795331271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUCb8Lcy89UQfJcZKAktnm4+xKTFfwjUrjGT4Fqtk5c=;
	b=UlQ3Fvo+YjoiRt8BeDheqtYjUnB4HzHMNNw8SpvBlxrzWT8qx+IEnFcmthsrTJwlN7vubV
	7s8WTOZdtaZiGkz1H7ZnlyS/HzaI6iSGhpfoN+dNSmsdevRilZyiozeF20A9rBJwWhRfKT
	4veurotAZmyk1mZBY2ZG5z1W7Hi6GSw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lxi5JrQF;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f20b304c0so227008585a.3
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 23:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795331270; x=1795936070; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yUCb8Lcy89UQfJcZKAktnm4+xKTFfwjUrjGT4Fqtk5c=;
        b=lxi5JrQFwv1hUdBuYpYdok+3SFaOtlwi01i09i8FrlK94SkxqwKpfLBrWLfVFpoJsP
         4NSAa7T70EfrB+nMJlwKIRpIX6Gu3ax3rbZ6hsEtRHw96/jrTTZpk3A3xYhi5Vo46tJC
         r6JQWSqANoEWYLjmujh/oaS0SyNgvgnwsqGHBnot12u2y6MZCa58STaQSCoXv0RnIuib
         8CC1Zd7UbdDTebnzeHK50xg4PI6gkfv/S7iQKAm+GHTDA6NNiU6ugKPKD+5AcOSZqHCo
         jpohSrMNBv4zcpHP/xbK3P0lAuRrYia3/lZqEkttxBFeAjhHQxIhkmrYSO5uzbthaW30
         0OmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795331270; x=1795936070;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yUCb8Lcy89UQfJcZKAktnm4+xKTFfwjUrjGT4Fqtk5c=;
        b=Rn+mFhG8ifWnUj7+BLoogsQm+eJVZ8sGWFn9LuV2ZElO6h1TCf1hQkI1AaV17V4tAG
         twr5ocGwaVI5Qv5xjPh8UoQMJ+QOK75qiOY/b12kIzIidx7pe4NUu+U0VkiPIkGAF2Cz
         VvUanB4Qd5xf0iPGTZTzMvtaOuBOqY5fK8TZybnEtb78nz+bNRktu9VM7THNzSBtiS+L
         vB/6a9WDP0xD/vmW2qrpwDE0HAKenao9taTZIqhSenF4aWOb/jJ7cq/h0MCQ5psNoicq
         ERFfkBE+gyJHNjmAuxWStFExBmK1rh/KgSFOkOoW95NAF/iuqNYQ9tMHaDu/o7HGkTxa
         dJPA==
X-Forwarded-Encrypted: i=1; AL+hErFhSaV4RxadxkxA7RsZ71ZjmRJIpl8GAttWw26Pj0RT8YWjLNxXT/tJtOIIN7G4o66Qn57K8bgeIg==@kvack.org
X-Gm-Message-State: APuU4Z/4JYIXfLEk3k0nFKKCK3h9WwAARxLhR1wtrf+SgAGmW5f0UMlk
	nIz+hfKGCUqoDF45LXBOuD8bsgOzJgYRTt33jQaiCv3yUALTpY3lFRm81z7WiPhYBSs=
X-Gm-Gg: AZFdTZdnP4319FGcp49q8jPG07wT9dGdPhRItxiyhp/tz3IRarOsw0Ajndb75zk+h+w
	r1xmIL5KEyxfAlbEbEtu3rQMDwxWB3NoQZ0jvvj4BsB/EdYEAV5XfXrLRHHyChTmWmrb62w9BHC
	46SKGf+ibS97QU6w88oL642/8CCGey/wFgPn/uhjn4GBa7u3CW6ip1CG0gml4ah2P3lidVcS1wZ
	GTPCnCvmeyhsCSDmybWpKOMKAOEoWUiBSBh30f2Wtp33Tz5eB9TRvkMRG7g0ZShvoe6pEINpeMQ
	JmALjtIPEcZXo9vjiEl/CUm3w8fDr1MvWCfA3Q65F068nSRcjx6C4nbiFkPWOrQPISVyy9GUmfA
	gacT5/GZwGPZtDLNV8F7eMitdSWhyT8mCOMSslNhOZIA8tz/XsaGKHToFqa/UObU19UDxmBW+Tn
	AI2EozZjs+wB3yF9JgpswiGD4EPERbYBmXg+1aTrNa5mhAc1+JdmCspqrX83g9L6wg616b3+PZ+
	5/KZRzKpn2cDsBAMhPZ88t+8iV0cT+5JywzdwrkDOy2VKCJbPWzneWutF/viUjwxNpHfXhn259E
	I2tWOOTu10S33nyXfJkycelU7xP/C0361Qt1xVTJQeTkTnCmA7iE49p2dZw9nU7dOzDDoZiSZxz
	hziBdf0c=
X-Received: by 2002:a05:620a:8387:b0:947:8f04:1c1b with SMTP id af79cd13be357-949ba7e4216mr1216194885a.3.1795331270129;
        Sat, 21 Nov 2026 23:07:50 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9213515f467sm69991526d6.41.2026.11.21.23.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 23:07:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] [v3] mm/mempolicy: fix copy_nodes_to_user() for
 odd inputs
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Arnd Bergmann <arnd@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
 larips <larips950@gmail.com>, stable@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
In-Reply-To: <20261120185248.823415-1-arnd@kernel.org>
References: <20261120185248.823415-1-arnd@kernel.org>
Date: Sun, 22 Nov 2026 02:07:48 -0500
Message-Id: <179533126873.412063.12506068140979067572.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0592980002
X-Stat-Signature: yjc5smn4spq7m9m4rdww5i5whfrwnm9e
X-HE-Tag: 1795331270-673604
X-HE-Meta: U2FsdGVkX19S18AH7MetJpISJHbZzGsUiTkZG3XxRosKyhYLdu33dBDomp53G9M8bm3/M6ra/e3mrUI4DjKFhr9P+SbQlVkH5BBfYUGuY8I0lsl/Seo52tJE4Qhn9X18MgjJZI50onLAc1X6Su0It7re5SIsUmE8bV5zLbu3xrEmmq0Bb1rnvVSy5CfCu/U4WG7ETN+IEDfFv3zaFoZOfZBaLAmx3K7bO7sdThovASORACK5/ccgDth9cUBfTS8Gb1ITQ+gBui5egR7PQ7O6W18atUmKYmbBhyPBj9NECSuO0XPxyu3FZel8n2k/btZT9Hrk/8ryGckTPjZFLK+vAqCH41z6id69nffuWs63AjcpL10/vA6Z5cfqXog3cbPPusGTnJAthLf47y/J66fLIxz5XRb9JoFBROCLccOlZpn1rJcqoqbGOiTUvtf655B5nyPqX3rYOkAOMseg79cd1QbJ5F73/FFUNvwPfXnE1y55wkbnhzl33VMbGnGJG0Djsp1AdFXinETzlcQvNR2jc2JThasOpHHUrn+RTi4akkh6c/kzMIaJ3ewKkXDECTBHi8sfjTyE7G5UoU3FBsofI8xxOeko8ZKI3qFYDs1qs+Ua0EVDpY6QBt79/0hS9vszNGsTEX7ReorwLaIlwn+LPwGsmTAMPRn3iRBLRput4lqhdSpbz+hCYncggkDVJ7vCTFIhD6cceZgkpbkLnphDCGfawOiLCruM540VeFj4q49NpFPLxpi7CwdxOzly+Az3iuwNATVUc2PvrXPCor4feEALS6u3QOE2ddY1QgBpmb/Q0KlZdsOIG2XSSL7FJC9McXKUKwlwKaQGcfPcfW84tH3y7kp6f99upWBqGDtqykfwBe+XpTnczjcw3yU+xx9akYGse7wzdsGdxeyRfZHc/Ez9xQdiDbRA7SPhhIisacfER8wlsaaEDCoM1bZKFAJ976yqf1USIzXCJTgcK8n
 BrPjpILT
 qI7nFcmX+9tvC5luI/4igrotyx97YVFOsT4fzPh/2FDssu+F/6Gtv8qQoNNEMZKd39bsfWmwO/UxK4AVUd99zay2CkUwFPXHOYQNwQlUwQhWf9SAwVEoxAHf34ZL6smDbxpYYGgm8+Q5ividUJ/t0+/NBWN/5rfoiasrbo4ZDvlYOMGHRfUURzI37rG5rwfx7B6tX2aNOwEHKT45EYnEvNNJ6KuKNnHWQcCWEclXg56ZyT6I7mELv2MLmBeor8qdM5s/4nEkB8kj4klXC59oiRtA1TQ1wnCADMQRCt6wm0IOaTzV5LqrJNiLbVzH7yEUBI2CpVR5jjCueidBsMsiBsFxiFm3OnKxFyQTv7Fuogbn5sJpplmIlhn67HjYMClFlEMDZkSHoDoTaY+K9Kb70R2CGsOfRamqbYjUD9yjXpekcE86Ek0QEkSp9jX9t56KIGr1KXr6j4xxp//7of/RyNu7HDa9zwIb7FE08FFS96jss4um23NAm3wyzhMBIJgAtAH1xgRlOYhmEDYNtuSprfeMNTfbTCQWV6E48RxG4U7fYXJyTnhQ83iT3Dc94malr3f5X6Jq02541VCUGrXVZrOt0/QVXx0/w4/mow85MtMgpaaVUP+VdOa21bY/DA7qKNFq6yhx+Z2PEQWDuD+pGx4h5QwkrMpTyhVo7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-20 19:52 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> copy_nodes_to_user() is broken for compat userspace in three
> distinct ways:
> 
>  - Passing a power-of-two size plus 1 as most normal userspace
>    does can end up calling compat_put_bitmap() with the wrong
>    size, copying an extra 32-bit word from the stack into
>    userspace and overflowing both arrays as compat_put_bitmap()
>    expects the actual number of bits, not the number plus 1.
> 
>  - Asking for an odd number of 32-bit words rounds up the
>    userspace buffer size full 64-bit words, leading to
>    an out-of-bounds access in userspace.
> 
> Fix the calculation of 'copy' to be based on the userspace
> word size and use this to for calculating the final number
> of bits to copy as well.
> 
> Reported-by: larips <larips950@gmail.com>
> Reported-by: Gregory Price (Meta) <gourry@gourry.net>
> Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
> Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.net/
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


