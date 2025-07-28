Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A126AC87FCB
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 15:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7F36B0095; Mon, 28 Jul 2025 11:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3687C6B0096; Mon, 28 Jul 2025 11:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E2A6B0098; Mon, 28 Jul 2025 11:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19F266B0095
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:19:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8F831402E9
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:19:31 +0000 (UTC)
X-FDA: 83714032542.23.064D2FD
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7B722180003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:19:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F4cDpLhA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753715969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLT/rylW6yNv3R9erMx+Eq7H8Q6DuqgDZ8LW1Wt7U98=;
	b=iFLmhgiVlWDymwCYbAD/aTGX5W8OhRhPmvI2YHQaQFqpqsIXkSuKT0MQJV90YVBObu1W6F
	e/9POm6sInNBr8/2qVQ6xCvbqhnqnLEO1nTLI9nDgMPFJEqUpVAVssJG8UX/uVE8RjR6Lw
	tNP5Xwkr3yTAW064SyGb0/ADQ4RhDgg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753715969; a=rsa-sha256;
	cv=none;
	b=pKUG+lmOuOfj5jTcnkkfjOpea+R+aKJ/vlPXHTerHBz/RlTrgCMTlGbicniDFZ/kPoJn57
	0enaR1T0PQQhPCCsxsSlJ4jQ/3Yi1Eg/ag2UvvOjejyBPg1gmAyXhwU6wuo/xBo63+lbjj
	IsjUzLh3h3EPtTnxCTt57SizBJvOtjA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F4cDpLhA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6fadd3ad18eso39016506d6.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753715968; x=1754320768; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLT/rylW6yNv3R9erMx+Eq7H8Q6DuqgDZ8LW1Wt7U98=;
        b=F4cDpLhAZKsJE37b/W3AeOY/WgNS4IOWGSfv+4jT9s/SgGOHxIxSpMHZ6bg0Cg5SCt
         3V+LjRgcwFllTHvpPwCFXIRqVk2vZ0vIpU2Eb7fRrcQpWaDwnfkrKdqGI7eckD2w93Nu
         9RBJd9QnHKlXQpp1yxlATpd5+3Ct+UGY+BhSaefQXj2FA+iH+x6ULHr8UHAMrLweAwhe
         9tTVXc7AWrCram1Bym+krgtpRvDJvKXeW65kG7xyTvqsM1CT6TekcMkejnlU5zvAskNG
         w7CB53npVTlBmV3hvhtq24rbVMR0J0v7KxPhEIWgJg9K2vov3Hd9AXJA6VLt26GkZHL8
         Qiig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753715968; x=1754320768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLT/rylW6yNv3R9erMx+Eq7H8Q6DuqgDZ8LW1Wt7U98=;
        b=Vqj7AUkpS1hUEfjagPaVrkMSKZsEQYk2ujfAImubbqQWc/AJRtcgbbbfEeY+VeT+Lu
         fo4luCkg5xdZvts4YdI2JGi5+PgymODDMDMg1fmsJ1/1oanSht6dIu4fyeDe0sPrG2Rj
         GbRRlKggBZtbPTpXD5ERFoULy9kuR8j6IaRPzud3aBfiH604uiNq0R7IXbLUjqJtHGtB
         Zo09B2K7/7g9ZTjwJOp50YPFOGCNdf/8Xc/CfDl3L7rATyxvjusdX/Eq/UK1DJvD1nlp
         5GZX6nSh5pTXkxScmEpTU3eaiFvYzHMrym1wI/Qndu5EvgngVHBM0MtLI3+juI/FB896
         lWTA==
X-Forwarded-Encrypted: i=1; AJvYcCV5lvHNLd36f3whIJMUL2hzOXdqDce4kauh1965hVyTnE/lFWRRZi4SZJHkfyP2khTE0uykY2afpw==@kvack.org
X-Gm-Message-State: AOJu0YzqbwGVMpTn8KKz7F5lLUQppXRgWSowcmftI8hnBiP7Fmrpota1
	uJ1Ltbj+J+jvA+mSiDi3s9GRqtCyDy4xx9dL94jmRTETKA1QnyNmeo6M
X-Gm-Gg: ASbGncuv1qjCk3fz6o778XR29UuYSrDzCVHXljUHIUxefY9JQ1Bpwrjgs/FJLz7Cb8b
	SxCjoBmiJu7xCvD7Jl2/Fr3XsMl9m6bJ0HUR31zt48vJdDnINF5dvYCTzT/oNgPNT8VZYqXDLBk
	YnPoOr+1687c9YtSomEEukLZcQ/XIiLGQYoObLwNMg9HUI6a8n90amaLTkCLKsUxz5EiibF1iy3
	peCJf1lFqZvOsqvKNdbkO/8Skp1sh6O4kAqHeskefmO6UqebMNHLTpxbUNWJz1v30V1IbSbYcyp
	3enbH8+ReQljhEEd3cuxE/AkgcWT4PVwe4/S5CO/gp0LZ/nSg+qVQnxiAkDiqiu6/4Br213W5r2
	XfM1sTWt1RWUNfH5gHwCZ6Ptf1wIEALVtn3/trwSDGQG4FscAZnUCPHSGIU8z2OoahriVW6Sp6l
	CooLmkqyduYFEwLvUOMvEr8vE=
X-Google-Smtp-Source: AGHT+IGlEJGZ736lYuT3B+uy3e0pPQZ8PHcz1E+GfL3FCPBW2RqUS72ySe2W7OLoiC9aSxN8YKFZKg==
X-Received: by 2002:a05:6214:27c7:b0:704:f4bf:10a7 with SMTP id 6a1803df08f44-70720603914mr182929196d6.45.1753715968021;
        Mon, 28 Jul 2025 08:19:28 -0700 (PDT)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e6438a480asm301681785a.86.2025.07.28.08.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 08:19:27 -0700 (PDT)
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0E887F40066;
	Mon, 28 Jul 2025 11:19:27 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 28 Jul 2025 11:19:27 -0400
X-ME-Sender: <xms:_pSHaIbdbrYl57tQvKWYOj0saP_1jp8hOg5MIVwDdeaJBi6NO-Q20Q>
    <xme:_pSHaOG7b5JC8MgVxjUC39REkmRzyQK1X19Mv_8DACg9OvDZSW4dd2rXoxWfGnrGq
    EH3sTlnzXvziasTkQ>
X-ME-Received: <xmr:_pSHaLruTLuLJa7mISvctoGZKXpGFnFPSX7MkDC38L81e0p6DIH_3xOnlEM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdelvdehudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveeiudffiedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqh
    hunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddu
    jeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvg
    drnhgrmhgvpdhnsggprhgtphhtthhopedujedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihgrmhdr
    hhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrsh
    htohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepohhjvggurgeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheprghnughrvgifjhgsrghllhgrnhgtvgesghhmrghilh
    drtghomhdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvthdprhgtphhtthho
    pegsjhhorhhnfegpghhhsehprhhothhonhhmrghilhdrtghomhdprhgtphhtthhopehloh
    hsshhinheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:_pSHaJxjqves7SvCOVB5W0svb2kBRDx4hpkRHAlGKUsSt8VOg0dLcQ>
    <xmx:_pSHaFNQH-49n3B8FAYoApumrgOka9W_QZQ5YEBsDTWCq4WEBzGukw>
    <xmx:_pSHaJdh5U712kScNCplLzjihOk5lpkQ-qSBepqxGXdggUDw_rcWPw>
    <xmx:_pSHaB4QMrmZImaBIdmJmE_aTpAzegTkSAuuWkaLtfG4oaQckOfRMw>
    <xmx:_5SHaJKDM8G_V5eGDKe16kbM0YYLdIbGCkGvymkagbV2FTuSXTddRCzi>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jul 2025 11:19:26 -0400 (EDT)
Date: Mon, 28 Jul 2025 08:19:25 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
Message-ID: <aIeU_RSpDYr8eYLz@tardis-2.local>
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
X-Stat-Signature: pyassxyfnwj3qiws7xhatkhc9nx5ktkx
X-Rspamd-Queue-Id: 7B722180003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753715969-428008
X-HE-Meta: U2FsdGVkX19hI+/CQ90lMirWiX463TdbpI9m3eIWKOROtjnk+vlFgHbhPuYZ6flguUWGzD9rhxlm6MsSDZum+De+GRVuPM90BqBIoA4W8aYeJLOLsTh5kUVDWAHPHEI/PkXiLQLwC19NjMGSyJIfNEwZn1+YDwl7j3+2UQYfbgwytfw931sNSDyMwRammPBY7jD1v5JlexOI76sLFqSPVwfW/6QRU2GMYv6M50iyOjMpQmS2goOgzEw0YQoIimwVge8MOlJ2Hs/ZyJA4ISMQOrRWMXsvFPfmsNNv1MzFinXauuNEhIApi6E3JvrxQnIOyO0zXvBqlmeY66ywS+zjbF3jqx27OaZ1g+e5fhh3TzN7DlY5q2eJ3hnfNM3Aqr823jvA3R7K8Bc54YCSUvXVPF5jZxN6lJroZljJX1v3QW2Y05NSf+s4p+HwaGrT7LStMKHbjlGkMIPrMxmSV+clP1MIVWRisFsOCtD+BjJDY2Us7hpaA2KqcAWS8f+0y5w4Zy3A4tkqJT7Kc1WgRUgA+/925Mv7dkNemcHB55Gxdz6YtXAcxp3n4frHAnB5G9voZpZJx2U+ETA6qOZf1bMVg3O+eUU83QcFGsTu1aj5Z1KoVt3b7WWo3VOXuu0d436OnAdDUzYPw/ynqrZ1vjgm3dHVWJlFHdicUzxDWUlUJSBZ57UyZ6UeQKQiXp7+Gs1gP5V0VGghCdoH32V2GO0y35FKO/bdRUi8dDBU4CRZxZQitUtQosC6u5G4YW7V7wE9KKDAWlL+pGqKB8GOgUFecIWavH01nnmldLkGYJFErybjMLUQ+W8rx3SV7shMfKqRXHgNfi0Dr2CGGV04tgxZTNl3zzXN0hcs1ZRw4Gvrz/MeOiW3alNAM4bFDrBDV+3RU5XLsaQs+cvyvtd+Lr0gR0pBCfZkL4hC/pNzuJ9RW+zom38XXVhEL0kYbu2wqqmBe70KVdfC8MS4vJntXwZ
 VltXouoG
 2MBIhjfImFvvRpHzJPbkhJ90XLkIWr47zYqJJwduluf6D6/uVYliRRdeHgoH9aCFbCBsWaLj/xq8ITf1svgqfzb5r+Fxw2AwCmmOZORF6ql/6R6nlIBYfDaIQNOYW5r9LjVCG5JYQ7Ao2KSRnrJ+zNCsea5q0BmYAXEexvg7OLZs/QPjB74kLDqqY9AsCu6s6kTtqCPO6tq9TSYpMVH0RLCOfHKXXKdeJOtPNKzZnwG8yEfSOQAuWg6iyMl2bf9kXc+Bl9oyEABhME/TJQoXcgL2r6yMGUWfxpVVdHJ2KMz2YqP2d8OuDJkMU6Isrv8rcnxglNn9hPWcVn9NfBNaT1qxDSX6C3OPUbHOLSV0fmlVRdF8dcL+dqcYWtlDpiTPhV5C1WfvhRkcV8BieI1GvXYkSQ58vwRFaPmK1T0OEBEiSoSox1VeVJuqMNk9cU2OjUjmVzE4MhC1399hU2rhE+TDgRCeIAWO+iRFutHxB/89kJck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 01:23:23PM +0000, Alice Ryhl wrote:
[...]
> +/// A reference to a [`MapleTree`] that owns the inner lock.
> +///
> +/// # Invariants
> +///
> +/// This guard owns the inner spinlock.
> +pub struct MapleLock<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);

So it's a guard, how about we name it `MapleGuard`, or `MapleLockGuard`,
or just `Guard`?

Regards,
Boqun

> +
> +impl<'tree, T: ForeignOwnable> Drop for MapleLock<'tree, T> {
> +    #[inline]
> +    fn drop(&mut self) {
> +        // SAFETY: By the type invariants, we hold this spinlock.
> +        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
> +    }
> +}
> +
[...]

