Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7EFFDEE39
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 00:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EECA76B0088; Thu, 23 Apr 2026 20:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75C56B008A; Thu, 23 Apr 2026 20:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16626B008C; Thu, 23 Apr 2026 20:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCF6D6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:17:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2790A120634
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:17:27 +0000 (UTC)
X-FDA: 84691535334.15.299B5D9
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3A7FD140005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:17:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JjQt0PTl;
	spf=pass (imf09.hostedemail.com: domain of wangli.ahau@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=wangli.ahau@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776989845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdbcbxpTtTZxFBtMUaFAEYUB7AjxIKSASl4Kxrqo+EI=;
	b=iLcPdSoDK4LjWWnini7bmB2FOez/cY6AZjZo2TQsTCeqUaot53v4smANVWKwbO3ciT17n2
	de9sdZMA0FYIOPON+XI40DzQMciUZiwpCO9Bx9Vc5ODZ6BAm06lM+mwg5cgy7OEwi9l+n0
	ZiGwZti2BrZbxof8vKYis48gzj8iNh4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JjQt0PTl;
	spf=pass (imf09.hostedemail.com: domain of wangli.ahau@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=wangli.ahau@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776989845; a=rsa-sha256;
	cv=pass;
	b=22QRsgVYMG+GVUSiyX+FDGewukEdrzEoiXt7OuIRi2cJ4otBADCPqxxen3VN2n4UPrNAQL
	0cRkikxYlkNP4eSWZAbiqM2Ik6x2Mk/o5US0zQvTTZdy7NYXRp4gnt7SACoUYS/rpU7whM
	J2oMmVNGtYZEijbk7SZHOmGB2uCSJp8=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50e5c5033f6so48565631cf.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776989844; cv=none;
        d=google.com; s=arc-20240605;
        b=Lu0+NnaQufoMvjhbliP9OjJ625YGvr7lycUUdp1/4gLu0T3kHWM0fum2m2x/zIV0jd
         uMt7EA8fZm9CrzQPD2jmHi0xw5COX/ZxhvQaO8+EzBF5saqk/ma7AqZbKSYquXa9QKv1
         FXuMvDYGQhn/wGoqrYy8Em3EoFNI4gXwwfZLyPTCPn5mRW33Y6jQ5br/zhtyKe0evq+S
         fHgBc+a3d8xt+C7bmM8MPJspG6w0DP//ze+SQ4YY71eooRSVmJ4dKNYX+klwBxqf92tS
         m8Utv9i4Ax52eRyFqg7SJvqnHAJ4LcYZoaYvF3ZK0oOCp68w1gSoWaaGBHwscztGsvr4
         sCMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FdbcbxpTtTZxFBtMUaFAEYUB7AjxIKSASl4Kxrqo+EI=;
        fh=OB4bR590DaBVZz6HMNnq9m7mALOtPMMemqwi2A00tkk=;
        b=evE5pSdEKLOJ+53dgT+skoW5o5bUIqA5oCnLnB20a+n7NPPlvRS5ks4Q3pFXq2+o36
         CdYLhhc37knkIkyP5eMk0HQgGlcF8AEaUXGF91C71XDl/QIU5i1I1JLIcjGC7fkN0Abt
         sdxRvv2sgDZbK58LVdQ7LBiD4RYoAUf5GUqNVJq5oUFio8aK0YjYHctkOUsIorD01STz
         TZVj4Vvys1jYFNZVGXWYogSC3lLL0q5IBpuuHC/Ln4xfQ8BIxEnjrPV6EWs6ADCIzb+j
         ZduWM1Ql9of8+yBE0oqO09MAl8hHr3hkLA63RJvCFFLOlAoZURKO+iB9nb77lKqqtsrL
         OTdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776989844; x=1777594644; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FdbcbxpTtTZxFBtMUaFAEYUB7AjxIKSASl4Kxrqo+EI=;
        b=JjQt0PTlTq6mp6RjxSyk+AKkmueZtaou1U1lUNUBox0Bstkn5x6RmkYdpoJ8Sif8tB
         DKBzyC9dtsPpH9ZrfQn3wkKCUDU05dMPmjG21NyNrtevpeAAauYMev1GjW+vILPjqf44
         Wmyuh4lbRlBEEPeMRWIbcXKSJsW7dWbHm38aTA3w8d5c71F/wCkkZAveQz29/pJ/+hAT
         YXFMwO1u+Sayp5o8/LwYnGRzX6fKlPIixw2JoiH1lJADbRINRD2NR/l3SpgLiVAONtdl
         o2erYYfyjeAV/TfDiIeAYQ/HT2eUjzkqhcE/D/VHvFupvEBBwuNF3kuhFiJlm0Q6ocB8
         54nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776989844; x=1777594644;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FdbcbxpTtTZxFBtMUaFAEYUB7AjxIKSASl4Kxrqo+EI=;
        b=RASvZWjB3MQvbAat76NQ4d547FqXnPViNjsgTbWQu8dxVPsNeR9cfudceyowZJ6peb
         alWg9Nsb3RjZpQNO+rOUlbCw+ZigO888Z0ZeiaIweXxE7Eny3LIlECZCofryUuS3UGBm
         anOVqVPsdSlw/IbVimYTSz6Yv2D2IsXt/E0Y9AIaovRDfyjE4lEb4XcYy8U8kkWa39fn
         RLKkFbx3LbnWMTlijp48UAMJiOlSrHt4tR4+EQhz3rPV4uzL+2ETbP0JGthsQ4JdIzRl
         QFebYVnk70s25V3lYzBzVB1GCm75cnCuGAEuJfU+stBXcHQzNWfdqQcDofnnOTBKqboN
         H17w==
X-Forwarded-Encrypted: i=1; AFNElJ8Xd2p1aOKpvTaqTdVZByWg7Yqs0RtVdDTS3HabQ1nY9YcdGAq+VLxHTCDT60TLs2OIQLip7KgvsQ==@kvack.org
X-Gm-Message-State: AOJu0Ywb8PvlN07DOZQCttRyWQsCTWc0cW/Fj3yniPPKMszv6LPDNm6I
	3lnkXDQBoi2j8a5XckyeauSeQbsYd7CPtxSVovx6fiXcNSdWkshhL5xb9UArrsBStF0AC72sUq5
	fUJpOIeQ28L1TUBV5RRlHDeZ3ybL+vA==
X-Gm-Gg: AeBDietAD89X07TBVZiJ92rAX7NOmL3aQjIqpRlqj/iTovFWCEGJXRjvlDsCK4ThFaS
	hKTymiZgioYyBCKowwQqcDNiJZCxGHTlrxdIvKJzD48EdIGKy4rvzQ7OEE8Br9BihzN+P22megV
	3GhIe+2FAApGq8eG/7iWhsWlbeEkqJk915cwPrx/fbFHbwZiMMcUHdTnY2890X9QC1C26OnmjH5
	yOCcVT01D7JUO2TbWIBr0X8EfUNtUqV1bZrbL0wEyFWeEMHTw+Up9hks8Xzg7zPloR65G4KD8N8
	BNCcGVFXtdI/LKTUgw==
X-Received: by 2002:a05:622a:1305:b0:50d:8db0:7abb with SMTP id
 d75a77b69052e-50e36ecfca9mr440201351cf.42.1776989844280; Thu, 23 Apr 2026
 17:17:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260422080446.26020-1-wangli.ahau@gmail.com> <7a762959-014c-4727-999f-a5073f9eaf7a@kernel.org>
In-Reply-To: <7a762959-014c-4727-999f-a5073f9eaf7a@kernel.org>
From: Li Wang <wangli.ahau@gmail.com>
Date: Fri, 24 Apr 2026 08:17:13 +0800
X-Gm-Features: AQROBzDVL2tftrpxjKYjdeKYAdmQKtLCLAzF9kdVNZECjlQvHjKJ9i_dwf6nu4k
Message-ID: <CANgNiRw_MVRF3f9JSWsThJGUrq353S5QXoGMWYttav7-7uW2-Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] selftests/mm: clean up build output and verbosity
To: "David Hildenbrand (Arm)" <david@kernel.org>, li.wang@linux.dev
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8o7yfr43p6zxrtys3ehrripip6w94z43
X-Rspamd-Queue-Id: 3A7FD140005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776989845-203905
X-HE-Meta: U2FsdGVkX1/89P5aPVuhnsk6E0Q29PJGmvC7rK5uZ5AzsnYbYwmR1LRYKZcWNGG4hLrVJ1ntJrSnfaTp633wtjQWg4fDC9nZgwupReqDo3zFO9DARprrxLB96kMxSgLLkQql8YsPqlUqrj5AHtYvhcGnJSwS4y+IT3jTD7FMZi778BwJ3UVtp6zoF0gCoS2lO6kpL2qjZZzNuvC2InpdCzMx27MQxa3XRnVWAGUdmkyW+znkD7yH7uTaIGZ3xuokPLOo8ZfjCvcF8Gl+nfgEk6YtAvQeec5sWPvN6lBwcnpccugjX0nFBHEE9Onj1kRCPmjbMILsJi1AgiPVDRKITKixs6kdfsx4aaWyP4L3F0RdcgW9dlA+bKuzK+SKB+3ArZ1jMgtBagmsVvN7+/517tgS/Y1C9IO1ch7tJXjh52rezlFo5+ZXxOUbkdpq8xrtT/h6GUfGgFCse+e2z5UvsIXlID9pR0eCeXUpqR/KFUmP7TYQcIYAPeTl3dX5c/xjCdL/vf4xqevxLREM8I96fO0TbGOxxYpB3xBJXB3Z8DyxLj447pscegAOmxKpGeZl1+7yApJpt7awhZKErg4uTUeli4sk3zPxtIGC1kVb9uE1QTwrBzWEBfgIPpTT0UmWnjWgFlc/fEr1bzpo4l7zqVacMioKNQXXR8OV0dhj3ZRFE43ORGspWVLo792sE98aML5Tr63leUo+Y4zozOCDnhMEaUfBu0P0OioLQxK0wnUKDCYyz5otlZXkeU2cdvGA4SdLUKpMeZTnnf8hzpgTYdR4yCHbsIvG3SI1x4+6kNIcGJTNl5ueLx6AWtqnS5TzTqkmUt3rWA+IdW/p3z3nzj3la+0fPlYzn+o+kRJgqXheFximw+i+ki+xBVkrVilSWHD7RkXuH6PdIqRB7jKlCXe+5RAk6Oli1QBnzRjkTBxNslfWcXSaL4L+IyJD3QDApizxFWXSPHz9CF/DPYt
 dgLl81vy
 5KKhbOEOhZdA7o8m49dJ89GR/0RHaDMYi4mewr/0pzqUNJ74zlmzBnjvjr88Jgu58zjWes66GiLtzsZAFhfBHr1pGNd8RWAYU/Iz3CM8TRa8bGMfT/+lHaH0/0J5IpP25z2q5sh5RkrPTcf9Uy6P2FE/gZxDyvYD6YXaDIqEFyg/ODXUdkpVwmW3FnPSfHFXhLyn58D8WyoVYGZoaSgSG8nLGPoRovdhXSDeIVOsR1MPQhIbN3cJAx/I6dbTdBkUsgt4Y3vvd9sWvP7DYBb/MxA4hZ01vC8I2nPb/P4MkDOPePt7tgSL3uM2R7svLpywEzSnYTs5PbKP+MWBBLwjlOdSO/mTrbZSUylOYz2/mCGICZeHMq+gb55WUrbn+KKZFmh1VRG0w6xjZpkVKvUW6FCxCJ1oimik1r6VKVeOAoB3U9rVoqKSFBYbGUjhk+MR+/Kys+qPe7V+Pnprs6ki7AgIDhsItvoxSVZcy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Arm) <david@kernel.org> wrote:

> On 4/22/26 10:04, Li Wang wrote:
> > Currently, the build process for the mm selftests is unnecessarily noisy.
> >
> > First, it leaks raw compiler errors during the liburing feature probe if
> > the headers are missing, which is confusing since the build system already
> > handles this gracefully with a clear warning.
> >
> > Second, the specific 32-bit and 64-bit compilation targets ignore the
> > standard kbuild verbosity settings, always printing their full compiler
> > commands even during a default quiet build.
> >
> > Notes:
> >   My email address has changed due to employment change.
> >   Previous Signed-off-by was with <liwang@redhat.com>.
>
> :(
>
> As a former RH'er, I'm deeply sorry for what has happened there, really.
>
> Thank you for continuing to contribute upstream, highly appreciated!

Thank you David, I got a new account from kernel org yesterday:

  li.wang@linux.dev

In the next, I hope to dedicate this email address to Linux and LTP
development work.

-- 
Regards,
Li Wang

