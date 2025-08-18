Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DB8CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9708E000E; Mon, 18 Aug 2025 02:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A18D8E0001; Mon, 18 Aug 2025 02:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20158E000E; Mon, 18 Aug 2025 02:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD7D18E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:40:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89C45138F0D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:40:31 +0000 (UTC)
X-FDA: 83788929462.28.BAF44FA
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81794100012
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:40:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QL/ok5EE";
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499229;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHRhDwyRYUb4TwjG35dT0f5D0HO6DNzP9EjaeHo4uJU=;
	b=iXcUeomS8Z6YU9jH6o373wCzpdJ7vWTzU1azQdcNJRDC51YE7mo0CTzhr+NFu6raZpm6cF
	a41bB3h60xmquxBNziSIVthgg+nnSRO6jCzZPEki89K+ZKpuEt5eXKWZZ31qXVDCI+r6ok
	bgUTI3Oa9ZhqaTcqfDpkp0mfdBHPYzE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QL/ok5EE";
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499229; a=rsa-sha256;
	cv=none;
	b=ok+AwP2D6iD/ThcwEl8fdr4VeiwDjnmk/QsuTAiNFeoUhDqh/7iDimId93baB0Q5x9VdGl
	HnNRqsajTjqY5L5PU2pzabMzGI+r5duVMs7VtzfHATZsc56wOyVOpoSJefIbATctwBqYEq
	H76dRKZohLAN3mR/kFm+W790vwPmzkc=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a1ac7c066so20406615e9.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 23:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755499228; x=1756104028; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lHRhDwyRYUb4TwjG35dT0f5D0HO6DNzP9EjaeHo4uJU=;
        b=QL/ok5EE/LWt/vVbt7LGoi5V7bE2Z7odWL2stwnba6nBIk96Yb8Ki6Sn+pP6m5dLxo
         QOoSBL4LgyTYOQZScg3U77+66YFKBla6b+h9axFDFh1+VH7pkmZEbCIues9d0lvr2KPk
         17008v5476VXeZqWsdD+8/49ksHxCmKfkwOS2bGuhZfq5LpJLZwdVYH6RNonpdxs3pAs
         nvuzxuGsMNnyejcnU5KrLBa6H3x+ugIKeGGfuX0RKIFz3hZEOHSNjgd/r+dJcNAOIwNV
         U87SIE5jrtxZluzmq5tQFjtuucMn1Zh5dbidgcTDFJ+bAp0J+0sS4oJ/V+hQl4eEecw9
         YQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755499228; x=1756104028;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lHRhDwyRYUb4TwjG35dT0f5D0HO6DNzP9EjaeHo4uJU=;
        b=hPIewzZCedBPv5WYuHgFHVjKLpFDs5SGpGiLT0ZDwreio1NSW6ZdfcN7ysOn07sxQg
         lDIjuZ7FAp9LKu2YFiJT+KTc22TL4sBaB42hsYgwAjl/EmpD6+kFwXPzy2pTNRQ3y9vm
         TfQJg0PvEtujas+yrj49hssQ9mwHbSi9EgGGDsNqFsG4UBFydftrQ8kVZfEGMv1NwJeY
         bg80+er+CY3k+1SV3ZV24f2wk3chDvHyn03FUMzLKBErmY4ybul0ZAePAAvL85VfAzuU
         6TjhrldQTjTKml21Ic2wpMUYHa2y6orRqOskwHDlkVdNkfzHykILe+bjh9SKN47QjVai
         hhYA==
X-Forwarded-Encrypted: i=1; AJvYcCVcJRBbseryf+WiefGfqMnPZ+I7hBg0gbxn710SfIxwxj0+PmF3uJ7x/LbM1YMJT3Q+U70c6JAxVw==@kvack.org
X-Gm-Message-State: AOJu0YwP0F7eTFnGSyAcEdEBNr4gY57S/rswuxhU7lkJlUIBWU4hygGe
	EDnX5+DFyd5Z4IJXnK/M4w4+R5Qc2rDSMgvVgaxKi0X6MHXewFnR51el
X-Gm-Gg: ASbGncuehu/8+urZiOfGOmkmlGW2cF/PYTEVoUvGVTLUXgKTGzgQcH1JzVhzI7TqW8s
	fJSk9PkiDrK9tORuaSw5uFGn1noaUfUZTr2/TLK9rhEkDrxyyS2xfXN4xSSADMwaoFDqLTxpq8G
	Ny6jFz3REiDzTHB0WuXCZl5TSoQY0uA/9G+Zwd6gcktBXs778aPujPM9kWLuJHxBLPP2oEmVoqV
	bkg0uJUBAWqulkRtKMz0ID9ECBHrOeJVOaHUHSxt1IsbIUzFXE/TSiD3ijs904px8HLIDrX4p35
	AJ1Kq3ZcrvFYZE8skiShmlC9HuJCIgKw2xHkW3puOurHGEqew7zSqGNHu8kzS/rOPk5mrw8TT04
	9EFS1QgDsKUgeoxRqJjfzKA==
X-Google-Smtp-Source: AGHT+IEklZkqqlj4pQE9hTOJwLOePZQxvYuZZS+FbaGplVr6in8Lz8zXjA+Qpx8rRj/KHhz0zm7o2w==
X-Received: by 2002:a05:600c:c104:b0:43c:ed33:a500 with SMTP id 5b1f17b1804b1-45a1b819ca7mr81403645e9.10.1755499227703;
        Sun, 17 Aug 2025 23:40:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c790689sm166654115e9.28.2025.08.17.23.40.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Aug 2025 23:40:27 -0700 (PDT)
Date: Mon, 18 Aug 2025 06:40:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, riel@surriel.com, harry.yoo@oracle.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [Patch v3 0/2] assert rmap behaves as expected
Message-ID: <20250818064026.htixfallwid3cdf4@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250818022905.15428-1-richard.weiyang@gmail.com>
 <20250817200642.c3ca3c89832fd9e0cb5117f4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817200642.c3ca3c89832fd9e0cb5117f4@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 81794100012
X-Rspam-User: 
X-Stat-Signature: fb6k1679af31khi3ze4e8pdrigpcwdcs
X-Rspamd-Server: rspam09
X-HE-Tag: 1755499229-387011
X-HE-Meta: U2FsdGVkX185BatGPZr3hnWWGFEeoFsDZM8nMbal6o3d4aoktj2DujRVgUO2sORW7l4EYFKP1vbiwT8lZmFgJSbH79XMyajHJ2MIZRnp3gwguJIVxONOdLwc+zvzHPEW0XefOHvlxZhGf1v2ztk2PMtnMiQM1p7I54jfgvyIf1fSCL3xGiBPFUaJ/NvRs3Xs3bgtY+5lAaXZa1fwaLxlz9SavHfs/dqgp4RiP3R0LBfuuWLU77h69f7aY6D1xQxczwkH8w+mdxVJSHmgEp5tQvtgjqtsCTC6953yyCdX9+u8M9rsf+SdT6PXc4nFdI0MT3SOWuxk8eNJMW49OPLxA7KK+rK3THzMG1vhfWl8mwFbaqiJVSqw0GEqdBLXHHMJdgyCY+ADWN0c1gx0HzsquPGeI5DufVDt6BG16ark7m/U7DsDTXhzK6Sn97ZTsyJDVWijJFIYjNMRUbnme05R6EHmshZLDDVmvhyBVYfKrU0QTf+r49htmUmfBPekbOGOWGQ2+yTJumHRfk8yIdMeOTbjw/dth+V760/+JLAhUVBa6qRp/jCttms2siZEEfIIFWiO7zeAI88TodVkfOea3Rbcm9YI6zrZwi6jv5oA3SF/xoQoWRZZHrffz7LRGemj0n9NKyNkZymFumEZ3xbfU11BCUTUu3cgkMcxzLfJZqNt8PfeLqel/KYyWDZPvpoMYunIR9b3JQZ6GhWNFB0U1UvnzBhiOwLw/WLo7JEo+/sTfWI/bWT+GTaWiguwKLt3CCZZylVieBk4yOxP3Py4adjoy5NKQSSFFwDCQbTgGSg6vN6GhDg8HQcgvYVr+a1J3P627BVxzOqrO2fB7ZAGihEUrBl7nj/vlIY2gD9R+F7x67eZdD7ZmGbjOhmmjVbZXDkhZ00/bX7f8R5LBDXLh3rMtxbopV7IgUxFOfizhHpTEVBOEy/CGFBtoraFGP2RGrbPIJX+0gYFBmB2qkM
 +EOnf/LF
 BMlPDB374l6HikkeRC2aDuHwcsAgDzbfAMhn3Rz1id/rDa97C7BkIh+oQnutOiY0v/f3ePujFJ8wC+mR8v/m5Jm2t4hCz9V/5pfDkiohqzB+zekk/ovilRyWLLnUVZyJOOnDZjVxXNLCLOj2f2FRn0Yfj6X4/Z90H+WkTcmtdFLqMqidfiLIo/Ji1niCqom1Jb+XeqkEY2YLf3OH2s45h6idYunSvRN2gRTSvhiKodC1KSSy9V8BWv3Zx17XRdk2Cuk/t+F1ZweYx3imW3byNtAJ60mfH2mcg4DCXMd86yBaL00vz/Q/MjKJyQCQkY3KlcVhhOnBM1nRCC9YZIzTEX/dVtOZzg3nvFQg6+VF4I+GDy+bQgB8clT39FwjYLhZA3p5edg+sicGU5YidEQSOaap2BA75vnSX3GVXF7oP5Ep1PBUOrjVYD0wmuAMeKywUnj9yfW1zbuAoBEd3Jd8gIl9mMfpFFh201AgckqgAWuT6oMaP+jYgcZvpbGn50sa0DpZucdhSfvVIjo5Taeu7ToD/uS42YaGpFJt/bP7Q+7N8h8ClpvwH58m4VHyGj/POS53s1Yoj4GPS25M2fhKieREBMMY62CNZahcNFlYabruMNLaPeTUdkABt0VmjbK4EhudCkKKkiTA+VcJLEV2xKX48+ji8g3NI5FoI6MmtM1phAzuiKGFuhDZSNB49nKPJ0uoAwSWz8W7jz8iOmgrxjQQ2Hi8OJyRV6XRbNsTw3pW/xlkGWPyx5wbMZIww5eA4SxZZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 17, 2025 at 08:06:42PM -0700, Andrew Morton wrote:
>On Mon, 18 Aug 2025 02:29:03 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> As David suggested, currently we don't have a high level test case to
>> verify the behavior of rmap. This patch set introduce the verification
>> on rmap by migration.
>
>I'm seeing many rejects here, so please redo against tomorrow's mm-new?
>

Sure.

>Also, seeing "assert" in the changelogs was a little surprising.  The
>term "assert" made me expect to see assertions, such as VM_BUG_ON(). 
>Perhaps "test that" would be clearer.

Will update it.

-- 
Wei Yang
Help you, Help me

