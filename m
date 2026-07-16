Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E8B6C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 16:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4CF6B00A5; Thu, 16 Jul 2026 12:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A51A6B00AB; Thu, 16 Jul 2026 12:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC2F6B00AD; Thu, 16 Jul 2026 12:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17ECD6B00A5
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:38:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99A4FA018C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:38:02 +0000 (UTC)
X-FDA: 84995196804.04.8BA2486
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id C5D1E20003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:38:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GcTYs4+i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784219880;
	b=6ywH/QBoTEHDgXtxslnu6QO+C1XLdS30y0D+4x8x9Ep0lD8oku6Lgo5GonBgnPSfKVTNOg
	IivieOfx+Godzg6flRVAeNpB2ZrbxbV3kqkFNXRleV0n1UsR3AcM4aSQeySN2zMAyMY3+f
	nv8ZKuzjO/pVyq2LlPB5EitFUXFjc14=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GcTYs4+i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784219880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgThJIHDvKsal8KFo6FMAaZQfGc1Wy8tJlIMPT0McxA=;
	b=TdvK5E/7URpjwwNgOWlfKtgoM1D2i1BEexm7XPYZu2FKudsFNjkoovWiY9FtrEdLG5UTuV
	INHl2rjN+4OnideyoG2rq5cIQbP8BCRrIV/2g2ZVu9boP8BNHVAeKV4sR74jL6NxSjLW3r
	X0e1OJidstmSznQKGWO9F6A+hW5PyC0=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-383adaa461fso2571301a91.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 09:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784219879; x=1784824679; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rgThJIHDvKsal8KFo6FMAaZQfGc1Wy8tJlIMPT0McxA=;
        b=GcTYs4+ivqVVqYOtkyDKv+j3J/Afpf6CpEQStmREN+DevHy/TQXo+XTjV8bROYbmQF
         /U468ZaRGuTW5pFvEKijXnAKytL3ZujgjzNWqugIWkJGDICtpl/QUKAdZI2HDrHtbLId
         A6wPKfB4oCz354vITZKDz5RLwT6rs3eHq8HQsSnYELKadLz1GAtTPqyail7VxpskY/or
         s/5KmuCPUvrNLw7Kp85WzMzHd4aQaDnpBt+olirQMpIlcvtZmERnCgZXBpdU5uwNzAPh
         O0L/cIBZVtEkHHRTCn3jFj1Q5ipcCSvFr9aZLWvNDTWyYG6JIwb33/LBW9QElKq04PDd
         g/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784219879; x=1784824679;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rgThJIHDvKsal8KFo6FMAaZQfGc1Wy8tJlIMPT0McxA=;
        b=DS8Vtikuz4afL4CFk23FH2yXiWY/sMmPAyEWEcoOO3XW1wC/ZzcvZbTTf/GJcR/PpP
         NqSWaUiw658AJrhdCf9RgKSpAjt3rMDGRzTX3OojGr9r41bN6T1WjthbUjxsXiUWZGZW
         0A/Y4DX13pgCtYqK38lKgf17Ugk/Jp7SY1f+wQo3zEGKKghS5MOX6N93m3/J5KhhPQCh
         D2tGwBcwkIUSUuOXeWFtmOwabXa6nU3ADX1JN878xh+syXdXrnQY2sgn4lIW+zXcexuQ
         75sW78zPiQXPFZWujufV9k3WSfG8arct6Fhwqhw/mBt83xFil2sr+2t9cObm/uirAJXI
         KcbA==
X-Forwarded-Encrypted: i=1; AHgh+RrswhyVYx4sa29ZQ8nECP6VTvCWwb9jkeE1tD0iykMyGVusd21wsnVkALUednUUtR/oJvlRi+eoGQ==@kvack.org
X-Gm-Message-State: AOJu0YxyHLcxrHrzVE9lv3gH0NUB8jCCi3Qfc/V37Sh5N0cEo1tPA+RT
	Q3t31/Z98GbQk/t+aKVPbT28HH+jdViiuR0oAxdwgoFWl2FEQJJA8R4J
X-Gm-Gg: AfdE7cky0LfMigm2Y17G4VGJ2Nb+ihwGrKERtXwSHVHegU4eJRt65wDYhwvm+gbmGg4
	4DGEBSvl+2IN7D75JI0G/OQrkvvJnMpyvmqg6iQ6xpMOlml9OAhds9UwDVUpmcUKmnF+ejdf9Op
	7286VReckNiXKAp6jbqC1OSbEZCLX5VeeBXi/Hbz2xK5qUHyg5CpC7VNx7As9Nk3K/FZf0KLgz+
	wYya7Kvps3tttyOJLynzFMe3WSHm03YP0z2xWrAY4P4C/GM/Hog+EUNgzX0yrJteaQqQciW0UxZ
	CfBuHQRPBOsMuY0zRcMV8RMfRZR74iiciL5bzfeKhnx7GiljVMajGbGR2us+wfSZN+HUkL6bQH/
	9bON2mbYsL+UpuQ+Bxm/4O226honfQnawRKrMUh6cdbklU9fBeI0l71jASGiYbrAarGkebDtULe
	+cZO0M6/ulmhX3AibqKZTfHYwwscKSe7OtsGSlwLZNHyoj
X-Received: by 2002:a05:6a21:e081:b0:3c3:7f8f:88cc with SMTP id adf61e73a8af0-3c37f8f9302mr5411998637.46.1784219879218;
        Thu, 16 Jul 2026 09:37:59 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258ff4402sm2078703a12.25.2026.07.16.09.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 09:37:58 -0700 (PDT)
Date: Thu, 16 Jul 2026 09:37:56 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, airlied@gmail.com,
	akhilesh@ee.iitb.ac.in, corbet@lwn.net, dakr@kernel.org,
	jgg@ziepe.ca, kees@kernel.org, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, lyude@redhat.com,
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com,
	mhocko@suse.com, mripard@kernel.org, nouveau@lists.freedesktop.org,
	ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org,
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org,
	surenb@google.com, tzimmermann@suse.de, vbabka@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <alkI5JLYPW211Ep7@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
 <alecaJ1FUso39D9k@skinsburskii>
 <alet21wLwM6P_Km2@lucifer>
 <ale3ydkx1xt6ruuP@skinsburskii>
 <20260715101432.99957d2d33203fafe4af2e1c@linux-foundation.org>
 <e9d0ade4-cf87-4e8d-90ec-50ddb5249b24@kernel.org>
 <aligdOKNwoOtD4io@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aligdOKNwoOtD4io@lucifer>
X-Rspamd-Queue-Id: C5D1E20003
X-Rspam-User: 
X-Stat-Signature: 5j9dity85xhcx5tyawog88t1twbkxejr
X-Rspamd-Server: rspam03
X-HE-Tag: 1784219880-580890
X-HE-Meta: U2FsdGVkX19VOskRKubc8UhhfY6slrscHf8QcBcVUyiN5h1ejceaCocunVZBV5bwzmfDCi7yLAUXuuaKTJKBvsP+qveVeKE6k1lHJxtXJqSIzjkVhiP81fAxPsQKWtLeKCF/8YG41K8tRJtLupnF8coKQMaE49Ck7TXyBjPkVqGL+HP91LSY4t62D6xWDcNEFPl8p2mg/JIKIYvSrmGQHqpoDFN+yiVt4+2+zxjWQg0mAHSWqLeUzYT8a8+JsWlTT/NUi1vsMYlF1sjLrftBP9oUqSuluydxruIJtLirH4zxJ3zC/7J7BphrUez3fLWS8FvpTjIhDoljnEJyt+Bx22tsdcde6wP8mFkUaKBcHAeHGc+M8teCUpiSi6KtPxGYyxZeGj+Z8alLQLuEjpdl17vCGWiaVDMJNcyxvEP4dfnu6LefghCpqgPTYEOnf8t/N3cT6Ed+w6v0soxHOftyl1PoDOEHdwVgVgYZUSTyWdXLaYG5jVUB/xt/lSi+NNqM1k75Bypg1VpLo1+mCy8kA9NWpQazeJ61gkRMFE5M2aHwhdpwOPW3Q51I4ZgsspcR2U3v3BiRjNxjS6YY4z9hdJRdNgjTt7GbSkwEc5sxN2+Uh3rTFbK/FQ7aQTP8ivjoBKJlFi/gMYkJ6T5Od4ZQDSl4Oq8LoRYFBZJ9cFvv13q+6UId6SRKGhfRcTa6P4phvfX0qAtC8GxZ1KJF9PkKzORC34FHhkCdeo69ReSCgBt1I7xvxS5npRgKfBgXBYqRxCUfRki8sZYmdBZiSXqhca1TGkFOdM+Typ+LBwcKrTipm1PssHa1ffWW8EwYr3ZDe4QXtCPn5j4Q4nDTmdayuq3YUxICsjJwi4wvmnoY7/qHTjPWsDsXKSlf6vlX1Gzez9HwV1F9+d7ypAjJVUmpe/f8Co+xdH1z5BfTCOc3P8BTQax/js47Mo6iPThWcekznUJTtg5l8SUKZb5PFE1
 IqEPY0oH
 5KUnYRbp2bMwbjFWPATdIbWHYgpSNXhl3CNu+TLAbikYxdJBNThPG27KJ9H9AU76H5P9YQIkqpWzDwlyb+5eI45HYow95un0GvFgdyuA01R2Sw5IXaAcwdJ+bWlutll/2cD4h1iv9JAnwtPibFiZhfd/uDy50Eluf33iXpf4Nx0O24HBreTCcyt5IUtR1sanE34Ad4S/jHlwclxcvtFg4kehj9UsC7tKfVn86vMinc/fAEXlK92VblTa15Bppo2lUWbpBm71OIlGZHp1u6hiFhTYK7YfX5Oxag8228CKxWyO6S+gOdBd0PoXfwI4d2e1elUjZe7+FxjiRz/U7y+f+WZ9giAx0bzvMZ5fPUCzBH95j8Ok3ZqwBz/U5C+7tWztkoIqNLSSanGuEAQmZJ8JjyiaeJmNbXun4jFn3+SusE7/A5OzGWvASManU4W3EYADw0bDpSi6Wp/1WVqXTA+a5w1qgwLRrNkfC4Us7B996yO93BtVcOzL+AXtsn4SQFrmx2oWq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 10:12:56AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Jul 16, 2026 at 10:59:56AM +0200, David Hildenbrand (Arm) wrote:
> > On 7/15/26 19:14, Andrew Morton wrote:
> > > On Wed, 15 Jul 2026 09:39:37 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > >
> > >>>
> > >>> Please don't do this, this is completely impossible to track for review :)
> > >>>
> > >>> mm review is currently very difficult based on volumes, it'll become impossible
> > >>> to manage if people sound fragments of series.
> > >>>
> > >>> Please just resend the whole thing at this point.
> > >>>
> > >>
> > >> Well, I followed the guidance provided by Andrew, and I believe he
> > >> applied all of the changes, including these, to the `mm` tree.
> > >>
> > >> Do you still want me to send v9 under these circumstances?
> > >
> > > Sure, if that's what reviewers prefer.
> > >
> > > This is a bit unfriendly to people who have already reviewed the code.
> > > Which is one of the reasons why I respond to a new version with a
> > > single diff showing reviewers (and the author, and myself) what changed
> > > since the previous version.
> >
> > As much as I dislike fixup patches, I tolerate them in reply to the existing series.
> >
> > But having some random fixup series is just crazy, really.
> >
> > --
> > Cheers,
> >
> > David
> 
> Yes.
> 
> Stanislav - also see Jason's suggestion - if you give a base commit then sashiko
> seems to work better. Maybe look at using b4 which does all of this for you
> automatically?
> 

Sure. Thank you all for the suggestions. I'll use b4 next time.

Thanks,
Stanislav

> Thanks, Lorenzo

