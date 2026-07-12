Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11B4C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 13:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73EF36B0005; Sun, 12 Jul 2026 09:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF226B0088; Sun, 12 Jul 2026 09:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDF86B0092; Sun, 12 Jul 2026 09:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36B2F6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:27:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B943D8EED3
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:27:22 +0000 (UTC)
X-FDA: 84980201124.18.A5B44A4
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 07AC5C0006
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:27:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vQWdo0Vp;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783862841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSgtWeg1aBZ0AWclvm9S4U5A86HaOMNd5qnnD7jgo3w=;
	b=eoNDsGeRzzW6pa5rFYudTsZnWk8L6JyAbCDsaUOun8b+PR5jDcuIFmLdBMw1YJ8Ar9KEmJ
	ad0eBkEYMBYm6sCWY22H283TzXsyd1MjyvqLIb2JfrtQx/jN6LPJvNmgKTpoyBxfS5geMG
	YSl/1NxncaUn6quWvK1BFQFlHR+XJh4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vQWdo0Vp;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783862841;
	b=Vqtj7MkULl1Ixt5DyBxAsJNQxHAXUb2UQ9kxzChyrXsYwPO7QgTR+7sMspBX18Hw3CUkge
	9FeFtk1ZMPxqExHa1eNcfOuHH/Y7K6JO7Wp2uI9Tfmi3LxMGYUHqsHIsYWyLKHq6Eq3Cja
	YJW1r5Ghg7W9eQ5/z5Z4/7lxcy8GiC8=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c08df8513so15040041cf.3
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783862840; x=1784467640; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uSgtWeg1aBZ0AWclvm9S4U5A86HaOMNd5qnnD7jgo3w=;
        b=vQWdo0VppuhKiTBYb4WmMovkA/6Vyb2LqPyHhlPdbGlecxH/Xeu5OnIJyKVVUcxlV+
         Nd4GobgQJYSzZsWJ9VszXThVOBnqHw7boS43oApVeXf9cZASa5gfA9O6oW0Lu6Jr4ZhR
         LoYauntV5vDZ1mh6ia1zmRMEuQIllr32JPgUDxsnMCOLRgfvivC0tAEl4cd9N014V9zN
         A7nOGqJqYNIz8v41MLqWa4A7k/MNvuf51svsaBZWQQRvI3WwF971PcKaoKQAFLaMOgHh
         jbeoO/8dzYY0xs4AzJDM8DA5SMYIx8QiDEN4MNjoM5n8LWZYbjPcgaETPqCp5f3kvg9+
         rbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783862840; x=1784467640;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uSgtWeg1aBZ0AWclvm9S4U5A86HaOMNd5qnnD7jgo3w=;
        b=Eoj3yn2ZwPMJyzkYkClrTOL2yqMt0QTjwXFBAirl2snaWAFHxLxct6wV8q+sUJol9z
         usHi1P/8yVOwnh5uLj7sovRzdrWDasM0AcUK78S/XsCSvQ4oQe4posOK6xg1p7DLJdOA
         5Z0cTL8HTSn9GAhMrrlVCzyOG1egd5CbSQbc1pe0sCifa64Mx8TOhFVeogyxKo/tyPen
         vp+GYJvY8dQYeczJk6cmgsoouhV6VnHtpKyuaFQe/5lJgNQ7Htl/Awb3Z/d284bD5sc3
         Z3Eq+TcJDT8ZjWf6bVOSLh1Ri/gup+q1BZuQ9oTDAex5oixvRw0n8Wv/NQEamJY9Yq5m
         Cong==
X-Gm-Message-State: AOJu0YwWul2ssuihz8t3jeXeWzWESB9Kl+rUyhV5KcvICkehU28FkMB9
	nLJT1ewtwPVm9ngdpavIIxdt7qY6iCAF57wciAvIe+TOy7otHQEWcXPLGdomelH+u6Y=
X-Gm-Gg: AfdE7ckBqyG5YSFkIWmhOitdYti8turtQWSHSxSrf8HV8t4Hk0DnR10YUh/Pyhsl/Fa
	3vGAlrclGauVweymjhCc3MwQ/Xxu1f6f1vc1w2cPXYq4e4v/4fsBcWwZjXUEnQ2dqBC6+2j28Br
	YjkBvDSAJrwqmjJcl5YX1few9Xm/dso3pu39oaa4em2wKdRuNobeiPgnoKF6CnVq+BO9S+W9I6U
	Maah3EcQ9NnfN7eFXhuJ01t9tBCuN4nzAQgE8wChy/V6fEGweF21GBM7sbFrJUwJsS5L3y5hUC/
	hsMV7FLqwGqKkDszLEPC+VW5EEarv8S1JLpKlDI37cWHAk5HEU3i0diXEZA6xJ+fvZnZ0+xfSjm
	mlcLwJs/Mg2/F+8JemqLCgAQOp7+Fpwu9I07kDLRaP3313uu/Nb3QFisyubVdHcZv6UzGXEJhsq
	I0Myb7Gn79UEhVUXCx6vt39JSuBdnOUUNkeeEyLB9b4dgHALtyxMbNK8hp2iWHo92AWRk7
X-Received: by 2002:ac8:5a47:0:b0:51a:8c99:1f18 with SMTP id d75a77b69052e-51cbf281a2bmr56325921cf.71.1783862840152;
        Sun, 12 Jul 2026 06:27:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caab6e9f4sm64833651cf.2.2026.07.12.06.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 06:27:19 -0700 (PDT)
Date: Sun, 12 Jul 2026 09:27:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Message-ID: <alOWMnIBleLQBBke@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
 <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
 <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
 <6a51920acece6_35cf3310061@djbw-dev.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a51920acece6_35cf3310061@djbw-dev.notmuch>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 07AC5C0006
X-Stat-Signature: e6wcm3i81u1tw5fx58h6wn7cwprqkihr
X-HE-Tag: 1783862840-555012
X-HE-Meta: U2FsdGVkX1+FLAj0vyGGunEklcht4FFGFIAo9S1EvQpfjSutCEB6+cBpqbAOphGay0tjbgX9VLsTq51uS5hVd3m41KEYEN639U8OnLCd5YcCmX94+XuvTtLMz/QNLsHIUFFA71o7RmDs1NyBx9m2dCoKyH70Lruk/dva5cZC2rROuuFVj6PsqgsBUPqgtqYBXgO/XpVUVWeBQuowWmh6mQdL7+DA3R55AXbecz5jGws0Jy4SUyHmo/CRSXul6WL2TLLqSHeEO+cKgpKk1elePJ9RFXZ7zUxcyvBE960q2HqibkHnkKGYiO8+8JUor4QXg+MpgM03QWOMkf5Xu8aC4+1Mnnlqjv73zpQUomz5U77AJ0MuVKBLD8hlIkqQSqBmgvy6ZItsEGflpMVstxAbNX83ltmBvcVFbIURquiS2EtVIQiZXVt5wZJNWlcbAvA8ROkHx4OFs7gVueI2+fGhr8QlsSkaJxYLbASccxLQ5XipdatHeU9qRuDMKihBxJWRvG3Z2hEq1j1oZjjK7bZpUhrmnh/usLG4e9OBAXuGtBR7s1ACsx8ffuAWg73+nSUs6zuAmixuf/b7jXIUTnetGrmTmT2FaTWOvQ57MEgmX5rc8O98nsXkIro+w4S8MKVz2EC8FB8hbQKMd1BosOv2jkXYY6Kd8W6O546Wlrp/M1B8BCwtd1lEVf0Y4YNDcNUu4xKqyfJLWvFASX1YvFRQesaDeIMphR9S5aNPtoxHYMgZ9kjA3CSOw9BZquACIEJHHVPv37qgAwoeu1AIjMcvXYMy0QaCCLF4pC9BmZJr7pbBmecDVdNoVLPleu7exoz/qDFyo3h5kBKpb1Kme/2uZiH1onCxSudA9PEB3PusEs6Zr7Mrt2/yE6He0cNvn1W/YmfTjqZHHqa4Y15TS6lVc/5FGUUVN36PydLFBKEUTseCp6ca5cEoiVPMYRUYspAg8dQzc6Rfx5wgiMS14y3
 8ZR0V0wy
 VoTGJhPN1AUrlGz+Zt1QjMj40I4KNm+vEcv4HEfAHwCFyqnUsPIokovxsxdKpXmqBfRDughD43UuhJkIePTbpWBCWSLAsuOQUmY9Q65cftiPr4po6Fr0FrBPXmFzNCaHlkpU5JskQc3ePoUcX0cYYjun95FRRSn4BJWqNZ0MMM/jIkhQbBNTpL9eWAIokYTZFyd60KStm1BxQ9p2FlDPxQTjhVX0rFbD7BYGpVFs6kDLQ8HTWjJXBRajY7hLrndHDgYKM+yq+wj5TGH0jn2cO8X3p1Djnr1NqCm5REOF6yaLM2/yc7e51rVBKEJ7GNVzHkpiErd4IzhnIBbFRn+nlrcmPAup4ML82s8SxfJnvPjiXVHex1sOD0NN9P3AusHN1WSiqyOrgT/NDW+cbarL6N3YMwpLse0/6rkaGld0+hNCvmCr4wWE6i5S4i1LbCY/uHPNfvdWkMQqnvRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 05:44:58PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > On Thu, Jul 09, 2026 at 06:08:45PM -0400, Gregory Price wrote:
> > > On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> > > 
> > > This was more a matter of having the DEFAULT set consistently across
> > > the dax driver variant probe() functions to make the behavior explicit.
> > > I didn't want an un-set value bug to creep in here somehow.
> > > 
> > > Happy to drop them if you think that's unneeded.
> > > 
> > 
> > Ah
> > 
> > Not setting the value in each of those places is equivalent to setting
> > MMOP_OFFLINE (0), so better to just set DEFAULT regardless.
> > 
> > So unless you have strong feelings i will keep them as-is.
> 
> Right, the mild feelings are only coming from the changelog mismatch
> which says "Oh no, device-dax drivers can not specify their online type
> besides the default" and all this series does is keep the status quo.
> 
> That can be had by just having unconditional:
> 
>      online_type = mhp_get_default_online_type();
> 
> ...in dev_dax_kmem_probe() and get rid of dev_dax->online_type until the
> first user arrives. If you are respinning the series and that patch
> drops, yay. If not, oh well.

Oh, it took me a second, I see what you're saying better.

I can drop .online type and follow up with the .online_type + CXL build
time patch as a separate series as you suggest.  Keeps this series
clean.

~Gregory

