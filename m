Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1911DCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78516940009; Fri, 19 Sep 2025 11:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C3B8E0019; Fri, 19 Sep 2025 11:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671FF940009; Fri, 19 Sep 2025 11:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 520758E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:07:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AF5758891
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:07:08 +0000 (UTC)
X-FDA: 83906327736.21.AEC181F
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id F221040016
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:07:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DS2233iK;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0X7gv2ca1L0/lLvJb6ek6nlX9wHB+NyrwieWqFd2Ims=;
	b=wbluLZoqjo4F+717I9TZPqxzXz5/QcDjzD8FKk6hiKB0/9ypQOAdlVSFv+NaUUDUzGqtjf
	DRE8TTPJvIiAd4PWbrZhaTKomV70f+4mHDgjeXt+iX+YYE8eWImBZsofnZtjjCMSZq/VHW
	ppk9ctBW1B5k8/m1DXMvimqgx/Nz2f0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DS2233iK;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294426; a=rsa-sha256;
	cv=none;
	b=VwLiTzGqbaBVGqCupwoM59cWUCbsLHuu9CW3AtuKI/8Koo/kBfAtrUT2hnnCa3xAegG0+k
	q82zhiW+k3g3vIuYjU/epUpiwyCUl4sj52yPDxU7eNZceyZrKuJvxxzMb9HQEw5dCp3u99
	KlLrabOC+UHazfk93dNTAZe0Wav/C/c=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-577dd4c1e84so2814295e87.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758294424; x=1758899224; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:to:date:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0X7gv2ca1L0/lLvJb6ek6nlX9wHB+NyrwieWqFd2Ims=;
        b=DS2233iKhMFI2d8ccL2YNPO8DSVprRomQRVo5oDV4GE/oU5/qy+ZxwjHHkabYyTIQt
         Cs+/rSZxKWqZDh2Zv8u0UFieVFYPGVKtx/41HAKwpTJxfHDQTn5tlwRufPf7l6fpEo4r
         IktO49+rCyPWpKEz0IIepyCVrY86Qbyy1rprjjdIzfzw08aOTOU7u1YbvDb+vF8IRoou
         Y0DU9yLAVkbwvCr1N5cbDDiZKVQEZVa7p+u2d1HZGb7+rHYK4Tb+90K9QkR7Q5WP19Ay
         C1iwr1gJL0HhfFE3G+AEou67oZVoSYjEJQI77l+ltZbUWFEPQHheMKfmKiSmkaXJBbry
         tNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294424; x=1758899224;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0X7gv2ca1L0/lLvJb6ek6nlX9wHB+NyrwieWqFd2Ims=;
        b=vvZw8oOJkFaXyHNWw8GVhxfI8N87t0PDn/5npW4HCqbhYtDLsUuEeMkbY8VzGwvbFk
         OOjqtESudFtZ+TPLnp7XaIP/wYyjT+YBL5yf4rOJLfjqbBisKHYMrMLT/EX7KJ3TghXN
         QTbF0LZtsPHUelkHvMslP2gMdJO6x+n0XzucBDaRBJq4CWqfLao8kzjXXAgodvQFNsFs
         IarhTv4/Ag28YNxGQ7vjp4Y2vE3Y4ll4R5t2pPstaPyyo/8Aowqq8d+8wXXc/0Zct099
         LGUh8kFcj6mcMgbc2/rSKvJhIA4TfLS+YpZ3XlVR6h6OW/3CR2SvHisNjs3jjWGpuYPT
         C9WA==
X-Forwarded-Encrypted: i=1; AJvYcCU/TUVT56bTpUjtpt8MhNJi/75ZuRJ00Md9OX7tw5iXxh8B7mOrFAurmDbNxeQXS3LFEwlEg+zSHw==@kvack.org
X-Gm-Message-State: AOJu0Yz3TIP0o0O+LDOX40Uk5MTjZFJwLmrmBACsXdPj27E4JVlUohtO
	WkowTkNrwfJSeVLUa2rKumeKXJju8l4vEaSo1EThzn/y9LrAYLB4FTQw
X-Gm-Gg: ASbGncsrMHvK+TXhsUBGQXsLT9ph6AGk4wKxLe/3RAO32li8vgCmyZTH5s+i5eY5vD6
	TmBYILOeotUrJwNJUmxPCY7boZyXxT0B2s0esFvgo+jSzyr89RWbOyO+c5kJBjjfjc9gh2barz4
	a/enFP7CxXX//qqn21pCBOWbtuFO0NU65YX2oluEUhIF8IMTECZX5Rrylq9IONwQYwKkftUIZMg
	UorcZqwf0uJXOwI6NyfwjYIddHpzTFUFhUcFLDr+zpitaPpZ7bBDCXtIMMspxxaanaMwSgxFzKa
	kCrUznky3tPvWEGVOnMS/acsqOKKMz2SW0i2vPdIEgR75X84E3DPEgbpB+lu4AFn6d/7DAyrr6N
	0
X-Google-Smtp-Source: AGHT+IHlcfeC9Aa/jvbPtaam41unsEAYkZd0ZLBNWZtY3ZSGc+Og1wqJBQuKyUq6sNnJxk0X88wdvw==
X-Received: by 2002:a05:6512:1598:b0:55f:4926:df1c with SMTP id 2adb3069b0e04-579e461b887mr1360111e87.46.1758294423504;
        Fri, 19 Sep 2025 08:07:03 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-579a1bacef8sm878143e87.103.2025.09.19.08.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:07:02 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 19 Sep 2025 17:07:01 +0200
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, paulmck@kernel.org,
	Jan Engelhardt <ej@inai.de>,
	Sudarsan Mahendran <sudarsanm@google.com>, cl@gentwo.org,
	harry.yoo@oracle.com, howlett@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	maple-tree@lists.infradead.org, rcu@vger.kernel.org,
	rientjes@google.com, roman.gushchin@linux.dev
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
Message-ID: <aM1xlYbvp13rOs6r@milan>
References: <20250913000935.1021068-1-sudarsanm@google.com>
 <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
 <f5792407-d2b9-42b3-bc85-ed14eac945ec@paulmck-laptop>
 <d1ef1cbb-c18d-4da6-b56b-342e86dca525@suse.cz>
 <CAJuCfpEQ=RUgcAvRzE5jRrhhFpkm8E2PpBK9e9GhK26ZaJQt=Q@mail.gmail.com>
 <aMpE-oSjtlDU4TSl@pc636>
 <CAJuCfpHQ_JedSRHKKoYXyVzaFOm=dDWzgFZwqerfEC1fn35j0w@mail.gmail.com>
 <CAJuCfpE48n=QM0nY8yE3drqZU0wgC76=70EyftL1WZewEcykyA@mail.gmail.com>
 <aMvx9GKgIWtrkZ_R@milan>
 <vhp6cqq6gx5xgs2ueo7az4wobs2rddjsucjwlxckx3us3p3pey@s62u2ruxkjw7>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <vhp6cqq6gx5xgs2ueo7az4wobs2rddjsucjwlxckx3us3p3pey@s62u2ruxkjw7>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F221040016
X-Stat-Signature: s9yzyn6pcpwti4fp3kzffp67eixzp131
X-HE-Tag: 1758294425-263237
X-HE-Meta: U2FsdGVkX19+3Fg60+0C09g8S/IBXUjGV7dsAYYiE97BaRqoaRGwxx5Z/CYUP/acyvY1hhvE78e/qY6ZKtlB3lsEmCYQvhltsts2Rv9lODIwKpLjUGTc/MSF0iNSiWqpTF3Cc24kSQg+NmC76NinAnMLPCZSmrrcLn/5bGSd04qRFVzilzy1+ppHteBiVpHrzV1wi3peHCQineatXVlIMVfujKp8PBmKvwsh7K7OSmiKabW4Q2TssZ8VsuiHVCcL4PsgpLTAZl5zdC2Rffi7FI6ZEaLqvNIuQM2NQTkmleMSqi18iVrMu+2N7lRWoTJKvG9OouRjsZ3PEVJ5PTNtAPm7D2OuI/HKoqFSCPqrnH8K2UJU1BO1DE+dVD7k/sleEx6rYGSOfjhbnw/WvuBgqt8Av3Ks0HSMdlGCbpajDDMriMzc3KJJqh3fIj+CLUgUP2uY9AhPKH8zA4F7i0ro8ROYnzMA4GmvbRDLDfuEvzD5qvsoo8wXQBPeX3EjRBu7J9uGJoFjgD07CFrSR3BJ70q4KGP4LXVKedKAkEKIxf4U4uP+WqgzFO/E+tuDOFMIRUWQ16rDXJam2Pv1y7lvtEF95Tu3WZ2EJu9tE7n/erpvyHS4ZGO1bA6gudlgbCw7Zck/IT7sK80UFsktSRjqsMBflfkkBy827Xg8YlG3IrfVzULZ7oTJlU7XTAaGxHoxeNAqxAjZ+ngtVDw5UoBXsu95leWd9c246HzB4Q/CYkZrzIvXr3zNu+aXZSnzwAADQ+Xix/QKB6CoJEmvnkZE3+1Q0K+2ANqq0YrOwJYVEN6x1qY5vRlj45qZT3cLZZNiY88Qm+ci7ei3jpUHf5ahuTKsTd5S1Yb/HwKTOwqWN4WVEJ5XfuC/vI5PKLeP8b260sMwzhqP6+QJYhdnGrFhS4GpcdzYjXj/cYtvixI9f2FzZcSnf+OQSKapdA09qP+vLk7zw51V5h4ftf/jo6d
 4nOS6dxd
 +Ed8kOI+H0e0kodo31MQauEc+5CKVNLXdwda2LDuY3dSfFLKBFsJYlCA8epGaz1KGz1fJawb5ITngHXINXNVwwcJ0cfU0wPLEN7Rq/Y3gZAoJzV07dIY8NBwmzaD7MFlQvDYtp1/eCTPNr1KM3r/U5mUMhMgdTDz8wgZbCxbXvfqr+n1G/IJMr6FJw17Q8v9ZwqwQHzS8kTVxnLmiXd9AjhU24vBTRtH0qMWskCFXe7VwcqOXhtVCJ35PGfSykXqPEc1kONiqFBBwDRvAyJzjW3+EFbX15BAmMrNnMTDYWehVWXZA8sC6b5B+U73fitFzZXhaIxLnwk6WkM4qiXMoGf2nFlN4Kq/c1YsTYiiWb+/2ZIENmIHHnZVYbN2ELu0CT/5ZR0bp0dIq7mMZcJ9GxyN2VW1COPDRDDup2J5vPp26YuQIZwNBmJPf2taWjbSmx5cBux7IgHJp+mUlCsL2UEeZRwl+MgM+tBgkuSI/qw/uG+AoD5WAOuThaVvV9uLFABLvmfiBcubP1wE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 11:29:14AM -0400, Liam R. Howlett wrote:
> * Uladzislau Rezki <urezki@gmail.com> [250918 07:50]:
> > On Wed, Sep 17, 2025 at 04:59:41PM -0700, Suren Baghdasaryan wrote:
> > > On Wed, Sep 17, 2025 at 9:14 AM Suren Baghdasaryan <surenb@google.com> wrote:
> > > >
> > > > On Tue, Sep 16, 2025 at 10:19 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> > > > >
> > > > > On Tue, Sep 16, 2025 at 10:09:18AM -0700, Suren Baghdasaryan wrote:
> > > > > > On Mon, Sep 15, 2025 at 8:22 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> > > > > > >
> > > > > > > On 9/15/25 14:13, Paul E. McKenney wrote:
> > > > > > > > On Mon, Sep 15, 2025 at 09:51:25AM +0200, Jan Engelhardt wrote:
> > > > > > > >>
> > > > > > > >> On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
> > > > > > > >> >
> > > > > > > >> >Summary of the results:
> > > > > > >
> > > > > > > In any case, thanks a lot for the results!
> > > > > > >
> > > > > > > >> >- Significant change (meaning >10% difference
> > > > > > > >> >  between base and experiment) on will-it-scale
> > > > > > > >> >  tests in AMD.
> > > > > > > >> >
> > > > > > > >> >Summary of AMD will-it-scale test changes:
> > > > > > > >> >
> > > > > > > >> >Number of runs : 15
> > > > > > > >> >Direction      : + is good
> > > > > > > >>
> > > > > > > >> If STDDEV grows more than mean, there is more jitter,
> > > > > > > >> which is not "good".
> > > > > > > >
> > > > > > > > This is true.  On the other hand, the mean grew way more in absolute
> > > > > > > > terms than did STDDEV.  So might this be a reasonable tradeoff?
> > > > > > >
> > > > > > > Also I'd point out that MIN of TEST is better than MAX of BASE, which means
> > > > > > > there's always an improvement for this config. So jitter here means it's
> > > > > > > changing between better and more better :) and not between worse and (more)
> > > > > > > better.
> > > > > > >
> > > > > > > The annoying part of course is that for other configs it's consistently the
> > > > > > > opposite.
> > > > > >
> > > > > > Hi Vlastimil,
> > > > > > I ran my mmap stress test that runs 20000 cycles of mmapping 50 VMAs,
> > > > > > faulting them in then unmapping and timing only mmap and munmap calls.
> > > > > > This is not a realistic scenario but works well for A/B comparison.
> > > > > >
> > > > > > The numbers are below with sheaves showing a clear improvement:
> > > > > >
> > > > > > Baseline
> > > > > >             avg             stdev
> > > > > > mmap        2.621073        0.2525161631
> > > > > > munmap      2.292965        0.008831973052
> > > > > > total       4.914038        0.2572620923
> > > > > >
> > > > > > Sheaves
> > > > > >             avg            stdev           avg_diff        stdev_diff
> > > > > > mmap        1.561220667    0.07748897037   -40.44%        -69.31%
> > > > > > munmap      2.042071       0.03603083448   -10.94%        307.96%
> > > > > > total       3.603291667    0.113209047     -26.67%        -55.99%
> > > > > >
> > > > > Could you run your test with dropping below patch?
> > > >
> > > > Sure, will try later today and report.
> > > 
> > > Sheaves with [04/23] patch reverted:
> > > 
> > >             avg             avg_diff
> > > mmap     2.143948        -18.20%
> > > munmap     2.343707        2.21%
> > > total     4.487655        -8.68%
> > > 
> > With offloading over sheaves the mmap/munmap is faster, i assume it is
> > because of same objects are reused from the sheaves after reclaim. Whereas we,
> > kvfree_rcu() just free them.
> 
> Sorry, I am having trouble following where you think the speed up is
> coming from.
> 
> Can you clarify what you mean by offloading and reclaim in this context?
> 
[1] <Sheaves series>
             avg            stdev           avg_diff        stdev_diff
 mmap        1.561220667    0.07748897037   -40.44%        -69.31%
 munmap      2.042071       0.03603083448   -10.94%        307.96%
 total       3.603291667    0.113209047     -26.67%        -55.99%
[1] <Sheaves series>

[2] <Sheaves series but with [04/23] patch reverted>
             avg             avg_diff
 mmap     2.143948        -18.20%
 munmap     2.343707        2.21%
 total     4.487655        -8.68%
[2] <Sheaves series but with [04/23] patch reverted>

I meant those two data results. It is comparison of freeing over
or to "sheaves" and without it in the kvfree_rcu() path.

--
Uladzislau Rezki

